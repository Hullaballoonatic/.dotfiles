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
      atuin
      bat
      carapace
      fnm
      htop
      neovim
      nushell
      pyenv
      starship
      stow
      topgrade
      tree-sitter-cli
      yazi
      zoxide
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

    if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      # shellcheck disable=SC1091
      . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    fi

    if ! command -v nix >/dev/null 2>&1; then
      log "Installing Nix..."
      nix_installer="$(mktemp)"
      trap 'rm -f "$nix_installer"' EXIT
      curl -fsSL https://nixos.org/nix/install -o "$nix_installer"
      sh "$nix_installer" --daemon

      if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        # shellcheck disable=SC1091
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      fi
    fi

    if ! command -v nix >/dev/null 2>&1; then
      abort "Nix is not available after installation."
    fi

    NIX_INSTALLABLE="path:$REPO_DIR#core"
    NIX_FEATURES=(--extra-experimental-features 'nix-command flakes')

    current_core_store_path="$(
      nix profile list 2>/dev/null | awk '
        /^Name:[[:space:]]+core$/ { in_core = 1; next }
        in_core && /^Store paths:/ { print $3; exit }
        in_core && NF == 0 { in_core = 0 }
      '
    )"

    desired_core_store_path="$(
      nix "${NIX_FEATURES[@]}" build --no-link --print-out-paths "$NIX_INSTALLABLE" | tail -n 1
    )"

    if [[ -n "$current_core_store_path" && "$current_core_store_path" == "$desired_core_store_path" ]]; then
      log "Nix profile core is already up to date."
    else
      if [[ -n "$current_core_store_path" ]]; then
        log "Removing existing core profile entry..."
        nix "${NIX_FEATURES[@]}" profile remove core
      fi

      log "Installing core packages into the Nix profile..."
      nix "${NIX_FEATURES[@]}" profile add "$NIX_INSTALLABLE"
    fi

    AUR_PACKAGES=(
      ghostty
      kdeconnect
    )
    # Ghostty is a temporary Linux exception for now.
    # NixOS should make this cleaner later, but the Nix build hits GTK/OpenGL issues here.
    log "Installing Ghostty via pacman..."
    sudo pacman -S --needed --noconfirm "${AUR_PACKAGES[@]}"

    mkdir -p "$HOME/.local/npm-global"
    npm config set prefix "$HOME/.local/npm-global"
  fi

else
  log "Skipping installation steps (--skip-install flag detected)."
fi

# ----------------------------------------
# Apply dotfiles via stow
# ----------------------------------------
log "Stowing global dot-files"
stow -d "$REPO_DIR" -t "$HOME" -R --adopt --no-folding --dotfiles home

PLATFORM="$(uname -s | tr A-Z a-z)"
PLATFORM_DIR="$REPO_DIR/platform/$PLATFORM"

log "Stowing $PLATFORM-specific dot-files"
stow -d "$PLATFORM_DIR" -t "$HOME" --adopt --no-folding --dotfiles home

log "Bootstrap complete."
