#!/usr/bin/env bash
# Wspólna logika instalatora testowego Shadow over Loathing PL.

PATCH_BUNDLES=(core)

resolve_game_streaming() {
  local root="$1"
  shift
  if [[ -n "${SOL_STREAMING:-}" ]]; then
    echo "$SOL_STREAMING"
    return 0
  fi
  if [[ -f "$root/game-path.env" ]]; then
    # shellcheck source=/dev/null
    source "$root/game-path.env"
    if [[ -n "${SOL_STREAMING:-}" ]]; then
      echo "$SOL_STREAMING"
      return 0
    fi
  fi
  local path
  for path in "$@"; do
    if [[ -d "$path" ]]; then
      echo "$path"
      return 0
    fi
  done
  return 1
}

game_backup_dir() {
  local streaming="$1"
  echo "$(dirname "$(dirname "$streaming")")/.sol_pl_backup"
}

file_size() {
  stat -c%s "$1" 2>/dev/null || stat -f%z "$1"
}

verify_platform() {
  local marker="$1/platform.txt"
  [[ -f "$marker" ]] || { echo "Błąd: brak $marker"; return 1; }
  [[ "$(tr -d '[:space:]' < "$marker")" == "steamos-proton" ]] || {
    echo "Błąd: paczka nie jest oznaczona jako SteamOS/Proton."
    return 1
  }
}

install_patches() {
  local patches="$1" streaming="$2" backup="$3"
  mkdir -p "$backup"
  local name target source
  for name in "${PATCH_BUNDLES[@]}"; do
    source="$patches/$name"
    target="$streaming/$name"
    [[ -f "$source" ]] || { echo "Błąd: brak patcha $source"; return 1; }
    [[ -f "$target" ]] || { echo "Błąd: brak pliku gry $target"; return 1; }
    if [[ ! -f "$backup/$name" ]]; then
      cp "$target" "$backup/$name"
      echo "  backup: $name ($(file_size "$backup/$name") B)"
    fi
    cp "$source" "$target"
    cmp -s "$source" "$target" || { echo "Błąd weryfikacji po skopiowaniu: $name"; return 1; }
    echo "  zainstalowano: $name ($(file_size "$target") B)"
  done
}

restore_patches() {
  local streaming="$1" backup="$2" name
  for name in "${PATCH_BUNDLES[@]}"; do
    if [[ -f "$backup/$name" ]]; then
      cp "$backup/$name" "$streaming/$name"
      echo "  przywrócono: $name"
    else
      echo "  brak kopii zapasowej: $name"
    fi
  done
}
