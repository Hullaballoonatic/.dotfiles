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

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

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

  if ! has_cmd pacman; then
    abort "pacman not found in PATH, but distro claims to be Arch-based."
  fi

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
  sudo yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
fi

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# ----------------------------------------
# Apply dotfiles via stow
# ----------------------------------------

log "Applying dotfiles with: stow home"
(
  cd "$REPO_DIR"
  # Explicitly set dir/target so this works even if .stowrc changes
  stow -d "$REPO_DIR" -t "$HOME" home
)

log "Bootstrap complete."

