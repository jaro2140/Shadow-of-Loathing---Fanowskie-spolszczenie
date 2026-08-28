#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# shellcheck source=../common/paths.sh
source "$ROOT/installers/common/paths.sh"
CANDIDATES=(
  "$HOME/.local/share/Steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.steam/steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.steam/root/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
  "$HOME/.var/app/com.valvesoftware.Steam/data/Steam/steamapps/common/Shadows Over Loathing/Shadows Over Loathing_Data/StreamingAssets"
)
GAME_STREAMING="$(resolve_game_streaming "$ROOT" "${CANDIDATES[@]}")" || {
  echo "Nie znaleziono gry."; exit 1;
}
restore_patches "$GAME_STREAMING" "$(game_backup_dir "$GAME_STREAMING")"
