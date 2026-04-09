#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /absolute/path/to/wallpaper"
  exit 1
fi

IMAGE="$1"

if [[ ! -f "${IMAGE}" ]]; then
  echo "File not found: ${IMAGE}"
  exit 1
fi

CONF="${HOME}/.config/hypr/hyprpaper.conf"

# Build explicit wallpaper lines per monitor for better compatibility.
mapfile -t MONITORS < <(hyprctl monitors 2>/dev/null | rg '^Monitor ' | awk '{print $2}')

{
  echo "# Managed by set-wallpaper.sh"
  echo "ipc = on"
  echo "splash = false"
  echo
  if [[ "${#MONITORS[@]}" -gt 0 ]]; then
    for mon in "${MONITORS[@]}"; do
      cat <<EOF
wallpaper {
    monitor = ${mon}
    path = ${IMAGE}
    fit_mode = cover
}

EOF
    done
  else
    cat <<EOF
wallpaper {
    monitor =
    path = ${IMAGE}
    fit_mode = cover
}

EOF
  fi
} > "${CONF}"

# Ensure hyprpaper is running with the current config.
if ! pgrep -x hyprpaper >/dev/null 2>&1; then
  hyprpaper -c "${CONF}" >/dev/null 2>&1 &
  sleep 0.4
fi

# Apply immediately via IPC using current hyprpaper syntax.
if [[ "${#MONITORS[@]}" -gt 0 ]]; then
  for mon in "${MONITORS[@]}"; do
    hyprctl hyprpaper wallpaper "${mon}, ${IMAGE}, cover" >/dev/null
  done
else
  hyprctl hyprpaper wallpaper ", ${IMAGE}, cover" >/dev/null
fi
