#!/usr/bin/env bash
set -euo pipefail

COMMAND="${1:-apply}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
DISTRO=""

if [[ "$OS" == linux && -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  DISTRO="${ID:-}"
fi

log() {
  printf '[dotfiles] %s\n' "$*" >&2
}

abort() {
  printf '[dotfiles] ERROR: %s\n' "$*" >&2
  exit 1
}

has() {
  command -v "$1" >/dev/null 2>&1
}


macos() {
  local formulae=(
    atuin
    bat
    carapace
    fnm
    htop
    neovim
    nushell
    pyenv
    sesh
    starship
    stow
    topgrade
    tree-sitter-cli
    yazi
    zoxide
  )

  local casks=(
    ghostty
  )

  has brew || abort "Homebrew is not installed."

  log "Updating Homebrew..."
  brew update

  log "Installing formulae: ${formulae[*]}"
  brew install "${formulae[@]}"

  log "Installing casks: ${casks[*]}"
  brew install --cask "${casks[@]}"
}

nixos() {
  log "Rebuilding NixOS configurration..."
  sudo nixos-rebuild switch --flake "$REPO_DIR/os/linux/distro/nixos"
}

arch() {
  local packages=(
    ghostty
    hyprland
    kdeconnect
    nvidia-settings
    scrcpy
    steam
    sunshine
  )

  local aur_packages=(
    protonup-qt
    noctalia-shell
    vesktop
  )

  log "Installing packages via pacman..."
  sudo pacman -S --needed --noconfirm "${packages[@]}"

  has yay || abort "yay is not installed."

  log "Installing AUR packages via yay..."
  yay -S --needed --noconfirm "${aur_packages[@]}"
  
  source_nix() {
    local nix_daemon=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

    [[ -r "$nix_daemon" ]] || return 0

    # shellcheck disable=SC1090
    . "$nix_daemon"
  }

  install_nix() {
    local installer

    log "Installing Nix..."

    installer="$(mktemp)"
    trap 'rm -f "$installer"' RETURN

    curl -fsSL https://nixos.org/nix/install -o "$installer"
    sh "$installer" --daemon
  }

  source_nix

  has nix || install_nix

  source_nix

  has nix || abort "Nix is not available after installation."

  local installable

  installable="path:$REPO_DIR/os/linux#core"

  nix profile remove core 2>/dev/null || true

  log "Installing core packages into the Nix profile..."
  nix profile add "$installable"
}

bootstrap() {
  case "$OS:$DISTRO" in
    darwin:*) macos ;;
    linux:arch) arch ;;
    linux:nixos) nixos ;;
    linux:*) abort "unsupported distro: $DISTRO" ;;
    *) abort "Unsupported OS: $OS" ;;
  esac

  apply
}

apply() {
  printf '%s\n' \
    "$REPO_DIR" \
    "$REPO_DIR/os/$OS" \
    "$REPO_DIR/os/$OS/distro/$DISTRO" |
    while IFS= read -r dir; do
      [[ -d "$dir/home" ]] || continue

      log "Stowing $dir"

      stow -d "$dir" -t "$HOME" -R --adopt --no-folding --dotfiles home
    done

  log "Apply complete."
}

update() {
  case "$OS:$DISTRO" in
    linux:nixos)
      log "Updating NixOS flake..."
      nix flake update "$REPO_DIR/os/linux/distro/nixos"

      nixos
      ;;
    *)
      has topgrade || abort "topgrade is not installed."
      topgrade
      ;;
  esac

  log "Update complete."
}

case "$COMMAND" in
  bootstrap) bootstrap ;;
  apply) apply ;;
  update) update ;;
  *) abort "Usage: $0 [bootstrap|apply|update]" ;;
esac

