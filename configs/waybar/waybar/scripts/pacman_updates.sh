#!/usr/bin/env bash
# Text output for Waybar custom module: pending pacman update count.
set -euo pipefail
n="$(checkupdates 2>/dev/null | wc -l)"
echo "${n//[[:space:]]/}"
