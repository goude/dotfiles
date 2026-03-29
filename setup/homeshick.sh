#!/usr/bin/env bash
# Install homeshick and clone dotfiles
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

REPOS="$HOME/.homesick/repos"

github_clone "goude/homeshick" "$REPOS/homeshick"

# shellcheck disable=SC1091
source "$REPOS/homeshick/homeshick.sh"

HOMESHICK_REPOS=(
  "goude/dotfiles"
)

for repo in "${HOMESHICK_REPOS[@]}"; do
  if [ -d "$REPOS/$(basename "$repo")" ]; then
    ok "$repo already cloned"
  else
    info "Cloning $repo..."
    homeshick --force --batch clone "$repo"
    ok "$repo cloned"
  fi
done

info "Linking dotfiles..."
homeshick --force --batch --quiet link
ok "Dotfiles linked"
