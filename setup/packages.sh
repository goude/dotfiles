#!/usr/bin/env bash
# Install base packages via apt or brew
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

COMMON_PACKAGES=(
  bat
  curl
  eza
  fd-find
  fish
  fzf
  git
  ripgrep
  tig
  tmux
)

install_apt() {
  info "Updating apt..."
  sudo apt-get update -qq

  local pkgs=("${COMMON_PACKAGES[@]}" duf libreadline-dev libsqlite3-dev libbz2-dev libffi-dev)
  info "Installing packages via apt..."
  sudo apt-get install -y -qq "${pkgs[@]}"
  ok "apt packages installed"
}

install_brew() {
  if ! has_cmd brew; then
    fail "Homebrew not found. Install it first: https://brew.sh"
  fi
  info "Installing packages via brew..."
  brew install "${COMMON_PACKAGES[@]}" duf
  ok "brew packages installed"
}

case "$OS" in
  macos)       install_brew ;;
  linux|wsl)   install_apt ;;
  *)           fail "Unsupported OS: $OS" ;;
esac
