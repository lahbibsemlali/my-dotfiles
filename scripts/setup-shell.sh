#!/usr/bin/env bash
set -euo pipefail

if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh is not installed. Run scripts/install-packages.sh first."
  exit 1
fi

# chsh only accepts shells listed in /etc/shells.
# Prefer the first zsh entry from there; fall back to command -v.
if [[ -r /etc/shells ]]; then
  ZSH_PATH="$(rg '/zsh$' /etc/shells -m 1 || true)"
else
  ZSH_PATH=""
fi

if [[ -z "${ZSH_PATH}" ]]; then
  ZSH_PATH="$(command -v zsh)"
fi

if [[ "${SHELL:-}" == "${ZSH_PATH}" ]]; then
  echo "Default shell already set to zsh."
  exit 0
fi

echo "Changing default shell to: ${ZSH_PATH}"
chsh -s "${ZSH_PATH}"
echo "Done. Log out and back in to use zsh."
