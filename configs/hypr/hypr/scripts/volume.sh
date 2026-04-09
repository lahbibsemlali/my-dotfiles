#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-}"

case "${ACTION}" in
  up) wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ ;;
  down) wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ;;
  mute) wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle ;;
  micmute) wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle ;;
  *) exit 1 ;;
esac

SINK_VOL="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
SINK_MUTED="no"
if [[ "${SINK_VOL}" == *"[MUTED]"* ]]; then
  SINK_MUTED="yes"
fi

if [[ "${ACTION}" == "micmute" ]]; then
  MIC_STATE="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)"
  if [[ "${MIC_STATE}" == *"[MUTED]"* ]]; then
    notify-send -a "volume" -r 9912 -h string:x-dunst-stack-tag:mic "🎙 OFF"
  else
    notify-send -a "volume" -r 9912 -h string:x-dunst-stack-tag:mic "🎙 ON"
  fi
  exit 0
fi

if [[ "${SINK_MUTED}" == "yes" ]]; then
  notify-send -a "volume" -r 9910 -h string:x-dunst-stack-tag:volume -h int:value:0 "🔇 Mute"
else
  VALUE="$(awk '{printf("%d", $2 * 100)}' <<<"${SINK_VOL}")"
  LABEL="🔊 ${VALUE}%"
  if (( VALUE < 35 )); then
    LABEL="🔈 ${VALUE}%"
  elif (( VALUE < 70 )); then
    LABEL="🔉 ${VALUE}%"
  fi
  notify-send -a "volume" -r 9910 \
    -h string:x-dunst-stack-tag:volume \
    -h int:value:"${VALUE}" \
    "${LABEL}"
fi
