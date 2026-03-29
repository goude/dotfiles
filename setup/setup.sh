#!/usr/bin/env bash
# Main setup orchestrator — run after cloning to get a working environment
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

printf '\n  \033[1mdotfiles setup\033[0m  (%s / %s)\n\n' "$OS" "$ARCH"

run_step() {
  local name="$1" script="$SCRIPT_DIR/$2"
  printf '\n  \033[1;36m── %s ──\033[0m\n' "$name"
  bash "$script"
}

run_step "System packages" packages.sh
run_step "Python (uv)"     uv.sh
run_step "Node.js (nvm)"   node.sh
run_step "Neovim"          neovim.sh
run_step "CLI tools"       tools.sh
run_step "Homeshick"       homeshick.sh

printf '\n  \033[1;32m✓ Setup complete.\033[0m\n'
printf '  Restart your shell or run: exec $SHELL\n\n'
