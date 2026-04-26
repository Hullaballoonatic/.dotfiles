#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------
# Helper functions
# ----------------------------------------

log() {
  printf '[dotfiles] %s\n' "$*" >&2
}

abort() {
  printf '[dotfiles] ERROR: %s\n' "$*" >&2
  exit 1
}

# ----------------------------------------
# Parse arguments
# ----------------------------------------

SKIP_INSTALL=false

for arg in "$@"; do
  case "$arg" in
    -s|--skip-install)
      SKIP_INSTALL=true
      ;;
    *)
      abort "Unknown argument: $arg"
      ;;
  esac
done

# Repo directory (where this script lives)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------
# OS detection
# ----------------------------------------

OS="$(uname -s)"

case "$OS" in
  Darwin)
    log "Detected macOS."
    ;;
  Linux)
    log "Detected Linux."
    ;;
  *)
    abort "Unsupported OS: $OS"
    ;;
esac

# ----------------------------------------
# Installation steps (unless --skip-install)
# ----------------------------------------

if [[ "$SKIP_INSTALL" == false ]]; then
  # ----------------------------------------
  # macOS branch (Homebrew)
  # ----------------------------------------
  if [[ "$OS" == "Darwin" ]]; then
    # CLI tools via brew formulae
    BREW_FORMULAE=(
      stow
      neovim
      yazi
      htop
      atuin
      starship
      nushell
      carapace
    )

    # GUI / app via casks
    BREW_CASKS=(
      ghostty
    )

    log "Updating Homebrew..."
    brew update

    log "Installing formulae: ${BREW_FORMULAE[*]}"
    brew install "${BREW_FORMULAE[@]}"

    log "Installing casks: ${BREW_CASKS[*]}"
    brew install --cask "${BREW_CASKS[@]}"
  fi

  # ----------------------------------------
  # Linux (Arch / Arch-based) branch
  # ----------------------------------------
  if [[ "$OS" == "Linux" ]]; then
    if [[ -r /etc/os-release ]]; then
      # shellcheck disable=SC1091
      source /etc/os-release
    else
      abort "/etc/os-release not found; cannot determine distro."
    fi

    if [[ "${ID:-}" != "arch" && "${ID_LIKE:-}" != *"arch"* ]]; then
      abort "This bootstrap script currently only supports Arch or Arch-based distros."
    fi

    log "Arch or Arch-like distro detected. Using pacman."

    PACKAGES=(
      stow
      neovim
      ghostty
      yazi
      htop
      atuin
      starship
      nushell
    )

    AUR_PACKAGES=(
      carapace-bin
    )

    log "Refreshing package database..."
    sudo pacman -Sy --noconfirm

    log "Installing packages: ${PACKAGES[*]}"
    sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

    log "Installing packages: ${AUR_PACKAGES[*]}"
    yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
  fi

  curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
else
  log "Skipping installation steps (--skip-install flag detected)."
fi

# ----------------------------------------
# Apply dotfiles via stow
# ----------------------------------------

log "Stowing common dotfiles with: stow --no-folding home"
stow -d "$REPO_DIR" -t "$HOME" --no-folding -D home 2>/dev/null || true

stow -d "$REPO_DIR" -t "$HOME" --no-folding home

PLATFORM_NAME="$(uname -s | tr A-Z a-z)"

log "Stowing platform-specific dot-files ($PLATFORM_NAME)"
stow -d "$REPO_DIR/$PLATFORM_NAME" -t "$HOME" --no-folding home

log "Bootstrap complete."

