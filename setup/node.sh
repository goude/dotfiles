#!/usr/bin/env bash
# Install nvm and Node.js
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

NODE_VERSION="${NODE_VERSION:-22}"
NVM_VERSION="${NVM_VERSION:-0.40.3}"

export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

if [ -s "$NVM_DIR/nvm.sh" ]; then
  ok "nvm already installed"
else
  info "Installing nvm $NVM_VERSION..."
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
  ok "nvm installed"
fi

# shellcheck disable=SC1091
source "$NVM_DIR/nvm.sh"

info "Installing Node.js $NODE_VERSION..."
nvm install "$NODE_VERSION"
nvm alias default "$NODE_VERSION"

# Minimal global packages for LazyVim LSP support
info "Installing global npm packages for LazyVim..."
npm install -g neovim prettier
ok "Node.js $NODE_VERSION ready"
