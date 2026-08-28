#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PATCHES="$ROOT/patches/steamos-proton"
# shellcheck source=../common/paths.sh
source "$ROOT/installers/common/paths.sh"
verify_platform "$PATCHES"
CANDIDATES=(
  "$HOME/.local/share/Steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.steam/steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.steam/root/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
)
GAME_STREAMING="$(resolve_game_streaming "$ROOT" "${CANDIDATES[@]}")" || {
  echo "Nie znaleziono gry."; exit 1;
}
if cmp -s "$PATCHES/core" "$GAME_STREAMING/core"; then
  echo "Patch PL: ZAINSTALOWANY (core zgodny bajt w bajt)."
else
  echo "Patch PL: NIEZAINSTALOWANY albo plik gry ma inną wersję."
  exit 1
fi
