#!/usr/bin/env bash
# Install latest stable Neovim
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

ensure_bin_dir

install_neovim_brew() {
  info "Installing Neovim via brew..."
  brew install neovim
  ok "Neovim installed via brew"
}

install_neovim_binary() {
  local nvim_dir="$HOME/.nvim"
  local tag tarball suffix

  # Determine the right binary for this platform
  case "$ARCH" in
    x86_64)  suffix="linux-x86_64" ;;
    aarch64) suffix="linux-arm64" ;;
    *)       fail "Unsupported architecture for Neovim: $ARCH" ;;
  esac

  # Fetch latest stable tag
  tag="$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | head -1 | cut -d'"' -f4)"
  tarball="nvim-${suffix}.tar.gz"

  info "Installing Neovim $tag ($suffix)..."
  ensure_dir "$nvim_dir"
  cd "$nvim_dir"

  curl -fsSLO "https://github.com/neovim/neovim/releases/download/${tag}/${tarball}"
  rm -rf "nvim-${suffix}"
  tar xzf "$tarball"
  rm "$tarball"

  ln -sf "$nvim_dir/nvim-${suffix}/bin/nvim" "$HOME/bin/nvim"
  ok "Neovim $tag installed"
}

case "$OS" in
  macos)       install_neovim_brew ;;
  linux|wsl)   install_neovim_binary ;;
  *)           fail "Unsupported OS: $OS" ;;
esac
