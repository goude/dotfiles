#!/usr/bin/env bash
# Shared helpers for setup scripts
set -euo pipefail

# -- Platform detection --

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

detect_arch() {
  case "$(uname -m)" in
    x86_64|amd64) echo "x86_64" ;;
    aarch64|arm64) echo "aarch64" ;;
    *) echo "$(uname -m)" ;;
  esac
}

OS="$(detect_os)"
ARCH="$(detect_arch)"

# -- Output helpers --

info()  { printf '  \033[1;34m→\033[0m %s\n' "$*"; }
ok()    { printf '  \033[1;32m✓\033[0m %s\n' "$*"; }
warn()  { printf '  \033[1;33m!\033[0m %s\n' "$*" >&2; }
fail()  { printf '  \033[1;31m✗\033[0m %s\n' "$*" >&2; exit 1; }

# -- Idempotent helpers --

has_cmd() { command -v "$1" >/dev/null 2>&1; }

ensure_dir() { [ -d "$1" ] || mkdir -p "$1"; }

# Ensure ~/bin exists and is on PATH
ensure_bin_dir() {
  ensure_dir "$HOME/bin"
  case ":$PATH:" in
    *":$HOME/bin:"*) ;;
    *) export PATH="$HOME/bin:$PATH" ;;
  esac
}

# Download a file only if the command isn't already available
# Usage: install_binary <cmd_name> <url> [dest]
install_binary() {
  local cmd="$1" url="$2" dest="${3:-$HOME/bin/$1}"
  if has_cmd "$cmd"; then
    ok "$cmd already installed"
    return 0
  fi
  info "Installing $cmd..."
  curl -fsSL "$url" -o "$dest"
  chmod +x "$dest"
  ok "$cmd installed"
}

# Git clone helper: prefers SSH if available, falls back to HTTPS
github_clone() {
  local repo="$1" dest="$2"
  if [ -d "$dest" ]; then
    ok "$repo already cloned"
    return 0
  fi
  if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    info "Cloning $repo via SSH..."
    git clone "git@github.com:${repo}.git" "$dest"
  else
    info "Cloning $repo via HTTPS..."
    git clone "https://github.com/${repo}.git" "$dest"
  fi
  ok "$repo cloned"
}
