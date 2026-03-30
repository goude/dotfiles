#!/usr/bin/env bash
# Install uv (Python package manager) and a current stable Python
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

PYTHON_VERSION="${PYTHON_VERSION:-3.13}"

if has_cmd uv; then
	ok "uv already installed"
	info "Updating uv..."
	uv self update 2>/dev/null || true
else
	info "Installing uv..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
	export PATH="$HOME/.local/bin:$PATH"
	ok "uv installed"
fi

info "Ensuring Python $PYTHON_VERSION is available..."
uv python install "$PYTHON_VERSION"
ok "Python $PYTHON_VERSION ready"
