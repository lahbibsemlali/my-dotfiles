#!/usr/bin/env bash
set -euo pipefail

choice="$(printf '%s\n' \
  'Toggle Bluetooth' \
  'Open Bluetooth Manager (GUI)' \
  'Open bluetoothctl (CLI)' \
  | wofi --dmenu --prompt 'Bluetooth' --width 420 --height 220)"

case "${choice}" in
  'Toggle Bluetooth')
    "${HOME}/.config/hypr/scripts/toggle_bluetooth.sh"
    ;;
  'Open Bluetooth Manager (GUI)')
    if command -v blueman-manager >/dev/null 2>&1; then
      blueman-manager >/dev/null 2>&1 &
    else
      notify-send -a bluetooth "Bluetooth" "Install blueman"
    fi
    ;;
  'Open bluetoothctl (CLI)')
    kitty -e bluetoothctl
    ;;
  *)
    exit 0
    ;;
esac
