#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-}"

case "${ACTION}" in
  up) brightnessctl set +5% >/dev/null ;;
  down) brightnessctl set 5%- >/dev/null ;;
  *) exit 1 ;;
esac

CURRENT_RAW="$(brightnessctl -m | awk -F, '{print $4}')"
CURRENT="${CURRENT_RAW%\%}"
notify-send -a "brightness" -r 9911 \
  -h string:x-dunst-stack-tag:brightness \
  -h int:value:"${CURRENT}" \
  "☀ ${CURRENT}%"
