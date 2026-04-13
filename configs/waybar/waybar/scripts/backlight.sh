#!/usr/bin/env bash
# Set backlight to a percentage (Waybar brightness menu). Uses brightnessctl.
set -euo pipefail
pct="${1:?usage: backlight.sh <percent>}"
brightnessctl -q set "${pct}%"
