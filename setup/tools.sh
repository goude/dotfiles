#!/usr/bin/env bash
# Install standalone binary tools (starship, shfmt)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

ensure_bin_dir

# -- Starship prompt --
if has_cmd starship; then
  ok "starship already installed"
else
  info "Installing starship..."
  sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes --bin-dir="$HOME/bin"
  ok "starship installed"
fi

# -- shfmt --
install_shfmt() {
  if has_cmd shfmt; then
    ok "shfmt already installed"
    return 0
  fi

  local shfmt_url
  case "${OS}-${ARCH}" in
    macos-x86_64)   shfmt_url="https://github.com/mvdan/sh/releases/latest/download/shfmt_darwin_amd64" ;;
    macos-aarch64)   shfmt_url="https://github.com/mvdan/sh/releases/latest/download/shfmt_darwin_arm64" ;;
    linux-x86_64|wsl-x86_64)  shfmt_url="https://github.com/mvdan/sh/releases/latest/download/shfmt_linux_amd64" ;;
    linux-aarch64|wsl-aarch64) shfmt_url="https://github.com/mvdan/sh/releases/latest/download/shfmt_linux_arm64" ;;
    *) warn "No shfmt binary for ${OS}-${ARCH}"; return 1 ;;
  esac

  info "Installing shfmt..."
  curl -fsSL "$shfmt_url" -o "$HOME/bin/shfmt"
  chmod +x "$HOME/bin/shfmt"
  ok "shfmt installed"
}

install_shfmt
