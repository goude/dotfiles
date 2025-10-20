#!/usr/bin/env zsh

source "$HOME/.homesick/repos/dotfiles/getaround.sh"
source "$HOME/.homesick/repos/dotfiles/aliases"
source "$HOME/.homesick/repos/dotfiles/functions"
source "$HOME/.homesick/repos/dotfiles/rc.common"

if command_exists starship; then
  eval "$(starship init zsh)"
fi

