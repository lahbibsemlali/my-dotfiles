#!/usr/bin/env sh
set -eu

if command -v bluetoothctl >/dev/null 2>&1; then
  if bluetoothctl show | grep -q 'Powered: yes'; then
    bluetoothctl power off >/dev/null
    notify-send -a bluetooth "Bluetooth" "Off"
  else
    bluetoothctl power on >/dev/null
    notify-send -a bluetooth "Bluetooth" "On"
  fi
elif command -v rfkill >/dev/null 2>&1; then
  rfkill toggle bluetooth
  notify-send -a bluetooth "Bluetooth" "Toggled"
else
  notify-send -a bluetooth "Bluetooth" "Install bluez / bluez-utils"
fi
