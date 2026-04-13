#!/usr/bin/env bash
# Install development packages (Docker, Node, Python tooling, etc.) on Arch Linux.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

DEV_PACMAN="${REPO_ROOT}/packages/dev-tools.txt"
DEV_AUR="${REPO_ROOT}/packages/dev-tools-aur.txt"
KICKSTART_REPO="${KICKSTART_REPO:-https://github.com/lahbibsemlali/kickstart.nvim.git}"

if ! command -v pacman >/dev/null 2>&1; then
  echo "pacman not found. This script is for Arch Linux."
  exit 1
fi

if [[ ! -f "${DEV_PACMAN}" ]]; then
  echo "Missing ${DEV_PACMAN}"
  exit 1
fi

mapfile -t DEV_PKGS < <(rg -v '^\s*(#|$)' "${DEV_PACMAN}" || true)

if [[ "${#DEV_PKGS[@]}" -eq 0 ]]; then
  echo "No packages listed in ${DEV_PACMAN}"
  exit 0
fi

echo "Installing dev packages (pacman)..."
sudo pacman -S --needed --noconfirm "${DEV_PKGS[@]}"

if [[ -f "${DEV_AUR}" ]]; then
  mapfile -t DEV_AUR_PKGS < <(rg -v '^\s*(#|$)' "${DEV_AUR}" || true)
else
  DEV_AUR_PKGS=()
fi

if [[ "${#DEV_AUR_PKGS[@]}" -gt 0 ]]; then
  if command -v yay >/dev/null 2>&1; then
    echo "Installing dev packages (AUR)..."
    yay -S --needed --noconfirm "${DEV_AUR_PKGS[@]}"
  else
    echo "Optional AUR packages are listed in ${DEV_AUR} but yay is not installed. Skipping AUR."
  fi
fi

if command -v docker >/dev/null 2>&1; then
  echo "Enabling Docker service..."
  sudo systemctl enable --now docker.service

  if id -nG "${USER}" | grep -qw docker; then
    echo "User ${USER} is already in the docker group."
  else
    sudo usermod -aG docker "${USER}"
    echo "Added ${USER} to the docker group. Log out and back in (or reboot) before running docker without sudo."
  fi
fi

if command -v nvim >/dev/null 2>&1; then
  NVIM_CONFIG_DIR="${HOME}/.config/nvim"
  NVIM_INIT="${NVIM_CONFIG_DIR}/init.lua"

  if [[ ! -d "${NVIM_CONFIG_DIR}" ]]; then
    echo "Installing kickstart.nvim from ${KICKSTART_REPO} into ${NVIM_CONFIG_DIR}..."
    git clone "${KICKSTART_REPO}" "${NVIM_CONFIG_DIR}"
  else
    echo "Skipping kickstart.nvim setup: ${NVIM_CONFIG_DIR} already exists."
  fi

  # Keep startup non-blocking: disable treesitter auto-install-on-open.
  if [[ -f "${NVIM_INIT}" ]]; then
    python - "${NVIM_INIT}" <<'PY'
import pathlib
import re
import sys

init_path = pathlib.Path(sys.argv[1])
text = init_path.read_text()
new_text = text

# Remove html from the default parser install list.
new_text = new_text.replace(
    "'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc'",
    "'bash', 'c', 'diff', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc'",
)

# Replace auto-install await block with a no-op return.
new_text = re.sub(
    r"elseif vim\.tbl_contains\(available_parsers, language\) then\s*"
    r"-- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done\s*"
    r"require\('nvim-treesitter'\)\.install\(language\):await\(function\(\) treesitter_try_attach\(buf, language\) end\)",
    "elseif vim.tbl_contains(available_parsers, language) then\n"
    "            -- Parser is known but not installed: skip auto-install on open to avoid blocking prompts.\n"
    "            -- Install manually when desired, e.g. :TSInstall html\n"
    "            return",
    new_text,
    flags=re.M,
)

if new_text != text:
    init_path.write_text(new_text)
    print(f"Patched treesitter behavior in {init_path}")
else:
    print(f"No treesitter patch needed in {init_path}")
PY
  fi
fi

echo "Dev tools installation complete."
