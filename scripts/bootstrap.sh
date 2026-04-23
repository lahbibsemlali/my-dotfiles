#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "[1/3] Installing packages..."
bash "${REPO_ROOT}/scripts/install-packages.sh"

echo "[2/3] Linking configs..."
bash "${REPO_ROOT}/scripts/stow-configs.sh"

echo "[3/3] Setting up shell..."
bash "${REPO_ROOT}/scripts/setup-shell.sh"

echo "Bootstrap complete. Restart terminal or log out."