#!/usr/bin/env bash
set -euo pipefail

WALL_DIR="${HOME}/my-dotfiles/wallpapers"
SETTER="${HOME}/.config/hypr/scripts/set-wallpaper.sh"
STATE_DIR="${HOME}/.cache/hypr"
STATE_FILE="${STATE_DIR}/last-wallpaper"

mkdir -p "${STATE_DIR}"

mapfile -t WALLS < <(rg --files "${WALL_DIR}" -g "*.jpg" -g "*.jpeg" -g "*.png" -g "*.webp")

if [[ "${#WALLS[@]}" -eq 0 ]]; then
  notify-send -a "hyprpaper" "Wallpaper" "No wallpapers found in ${WALL_DIR}"
  exit 1
fi

LAST=""
if [[ -f "${STATE_FILE}" ]]; then
  LAST="$(<"${STATE_FILE}")"
fi

if [[ "${#WALLS[@]}" -eq 1 ]]; then
  PICK="${WALLS[0]}"
else
  PICK="${LAST}"
  while [[ "${PICK}" == "${LAST}" ]]; do
    PICK="${WALLS[RANDOM % ${#WALLS[@]}]}"
  done
fi

"${SETTER}" "${PICK}"
printf '%s\n' "${PICK}" > "${STATE_FILE}"

NAME="$(basename "${PICK}")"
notify-send -a "hyprpaper" -h string:x-dunst-stack-tag:wallpaper "Wallpaper" "${NAME}"
