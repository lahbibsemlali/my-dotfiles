#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

PACMAN_FILE="${REPO_ROOT}/packages/pacman.txt"
AUR_FILE="${REPO_ROOT}/packages/aur.txt"

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found. This script is for Arch Linux."
  exit 1
fi

if [[ ! -f "${PACMAN_FILE}" ]]; then
  echo "Missing ${PACMAN_FILE}"
  exit 1
fi

# Fallback to standard grep if rg is not installed
GREP_CMD="grep"
if command -v rg >/dev/null 2>&1; then
  GREP_CMD="rg"
fi

mapfile -t PACMAN_PKGS < <(${GREP_CMD} -v '^\s*(#|$)' "${PACMAN_FILE}" || true)

if [[ "${#PACMAN_PKGS[@]}" -gt 0 ]]; then
  echo "Installing pacman packages..."
  sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
else
  echo "No pacman packages to install."
fi

if [[ -f "${AUR_FILE}" ]]; then
  mapfile -t AUR_PKGS < <(${GREP_CMD} -v '^\s*(#|$)' "${AUR_FILE}" || true)
else
  AUR_PKGS=()
fi

if [[ "${#AUR_PKGS[@]}" -gt 0 ]]; then
  if command -v yay >/dev/null 2>&1; then
    echo "Installing AUR packages with yay..."
    yay -S --needed --noconfirm "${AUR_PKGS[@]}"
  else
    echo "AUR packages listed but yay is not installed. Skipping AUR."
    echo "Install yay first, then rerun this script."
  fi
fi

echo "Package installation complete."