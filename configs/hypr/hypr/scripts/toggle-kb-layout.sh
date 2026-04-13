#!/usr/bin/env python3
"""Cycle Hyprland xkb layout on every keyboard (us <-> ara, ...)."""
import json
import subprocess
import sys

try:
    out = subprocess.check_output(["hyprctl", "devices", "-j"], text=True)
except (FileNotFoundError, subprocess.CalledProcessError):
    sys.exit(1)

data = json.loads(out)
for kb in data.get("keyboards") or []:
    name = kb.get("name")
    if name:
        subprocess.run(["hyprctl", "switchxkblayout", name, "next"], check=False)

# Optional: show active keymap if present in hyprctl JSON
try:
    out2 = subprocess.check_output(["hyprctl", "devices", "-j"], text=True)
    d2 = json.loads(out2)
    kbs = d2.get("keyboards") or []
    label = (kbs[0].get("active_keymap") or "Switched") if kbs else "Switched"
except (subprocess.CalledProcessError, json.JSONDecodeError, IndexError):
    label = "Switched"

subprocess.run(
    ["notify-send", "-a", "hyprland", "-t", "1200", "Keyboard", str(label)],
    check=False,
)
