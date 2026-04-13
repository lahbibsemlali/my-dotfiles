#!/usr/bin/env sh
if command -v bluetoothctl >/dev/null 2>&1; then
  bluetoothctl show | grep -q 'Powered: yes' && bluetoothctl power off || bluetoothctl power on
elif command -v rfkill >/dev/null 2>&1; then
  rfkill toggle bluetooth
else
  notify-send 'Bluetooth' 'Install bluez / bluetoothctl'
fi
