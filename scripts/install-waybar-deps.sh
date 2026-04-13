#!/usr/bin/env bash
# Installs packages Waybar in this repo expects (pacman + AUR). Safe to re-run.
set -euo pipefail

sudo pacman -S --needed pacman-contrib alsa-utils bluez bluez-utils

if command -v yay >/dev/null 2>&1; then
  yay -S --needed wlogout
elif command -v paru >/dev/null 2>&1; then
  paru -S --needed wlogout
else
  echo "Install an AUR helper (yay/paru), then: yay -S wlogout" >&2
  exit 1
fi

echo "Done."
