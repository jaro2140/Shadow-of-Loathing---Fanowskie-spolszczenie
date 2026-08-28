#!/usr/bin/env bash
# Instaluje testowy patch Shadow over Loathing PL na SteamOS przez Proton.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PATCHES="$ROOT/patches/steamos-proton"
# shellcheck source=../common/paths.sh
source "$ROOT/installers/common/paths.sh"

[[ "$(uname -s 2>/dev/null || true)" == Linux* || "${SOL_TEST_MODE:-0}" == "1" ]] || {
  echo "Ten instalator jest przeznaczony dla SteamOS/Linux z Protonem."
  exit 1
}
verify_platform "$PATCHES"

CANDIDATES=(
  "$HOME/.local/share/Steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.steam/steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.steam/root/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
)
if ! GAME_STREAMING="$(resolve_game_streaming "$ROOT" "${CANDIDATES[@]}")"; then
  echo "Nie znaleziono gry. Skopiuj game-path.env.example do game-path.env i wpisz ścieżkę."
  exit 1
fi

BACKUP="$(game_backup_dir "$GAME_STREAMING")"
echo "=== Shadow over Loathing PL — instalacja testowa SteamOS/Proton ==="
echo "Gra: $GAME_STREAMING"
echo "Patch: $PATCHES"
install_patches "$PATCHES" "$GAME_STREAMING" "$BACKUP"
echo "Gotowe. Kopia angielska: $BACKUP"
