#!/usr/bin/env bash
#FIXME:it would be great if this could also support cloning the git@ ssh version also, if such access is available. otherwise clone the https version

REPOS=$HOME/.homesick/repos
git clone https://github.com/goude/homeshick.git "$REPOS/homeshick"
# shellcheck disable=SC1091
source "$REPOS/homeshick/homeshick.sh"

echo "Cloning homeshick repos..."

homeshick_repos=(
	"goude/dotfiles"
)

for i in "${homeshick_repos[@]}"; do
	homeshick --force --batch clone "$i"
done

echo "Silently and forcefully linking homeshick..."
homeshick --force --batch --quiet link

echo "Done."
