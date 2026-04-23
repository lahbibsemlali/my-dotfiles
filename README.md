# My Hyprland Dotfiles

Minimal, reproducible Arch Linux + Hyprland setup with modular configs and helper scripts.
Refactored for maintainability, fast startup, and GNU Stow compatibility.

## Preview

![Wofi Launcher](assets/wofi-preview.png)
*Wofi application launcher with Waybar*

![Btop System Monitor](assets/btop-preview.png)
*Btop++ system monitor with resource graphs*

## What This Repo Manages

- Package manifests (`pacman` + AUR)
- Install/bootstrap scripts (Idempotent and safe)
- Hyprland, Waybar, Wofi, Kitty, Dunst, Cursor configs (Modularized)
- Shell setup (`zsh`, `eza`, `fzf`, `zoxide`, `fastfetch`) (Split into aliases, exports, options, plugins)
- Wallpaper curation and rotation scripts

## Repository Structure

- `configs/` symlinked to `~/.config` via stow (e.g. `configs/hypr/hypr` -> `~/.config/hypr`)
- `configs/home/` symlinked to `~` (for dotfiles like `.zshrc`)
- `packages/` package lists used by install scripts
- `scripts/` bootstrap and utility scripts
- `wallpapers/` local wallpaper library (images ignored by git)

## Quick Start

```bash
git clone <your-repo-url> ~/my-dotfiles
cd ~/my-dotfiles
bash scripts/bootstrap.sh
```

## Key Scripts

- `scripts/bootstrap.sh` full system setup: packages + stow configs + shell setup.
- `scripts/install-packages.sh` install from `packages/pacman.txt` and `packages/aur.txt`
- `scripts/stow-configs.sh` securely link configs into your home directory (creates base dirs automatically).
- `scripts/setup-shell.sh` set default shell to zsh safely.
- `scripts/install-dev-tools.sh` install Docker/Node/Python/neovim + kickstart.nvim bootstrap.
- `scripts/import-dharmx-walls.sh` import curated wallpaper subsets.

## Wallpapers

### Import curated wallpapers

1. Edit categories in `wallpapers/sources/dharmx-categories.txt`
2. Import a small subset:

```bash
PER_CATEGORY=4 bash scripts/import-dharmx-walls.sh
```

### Set and rotate wallpapers

- Set a specific wallpaper:
  - `~/.config/hypr/scripts/set-wallpaper.sh /absolute/path/to/image.jpg`
- Set a random wallpaper:
  - `~/.config/hypr/scripts/set-random-wallpaper.sh`
- Keybind:
  - `SUPER + SHIFT + W` picks a random wallpaper

## Notes

- Keep all changes in this repo, then run `scripts/stow-configs.sh`.
- Scripts are designed to be idempotent and run safely multiple times.

## Credits

Waybar configuration in `configs/waybar/waybar/` (including `config.jsonc`, `style.css`, XML menus, and `scripts/`) comes from [Firstp1ck/Hyprland-Simple-Setup](https://github.com/Firstp1ck/Hyprland-Simple-Setup) (GPL-3.0). That project expects a larger stack (extra Hyprland scripts, optional tools such as `wlogout`, SwayNC, `waybar-module-pacman-updates`, Razer/LM Studio helpers, etc.); adjust paths and install missing pieces if something does not load.