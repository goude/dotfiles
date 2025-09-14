#!/usr/bin/env bash

# source $HOME/.homesick/repos/runcom2/rc.common
#
# source $HOMESHICK_REPOS/homeshick/completions/homeshick-completion.bash
# source $RUNCOM2_PATH/utils/bash_colors
#
# source $RUNCOM2_PATH/rc.common-post
#
# # Workarounds
# source $RUNCOM2_PATH/utils/fix_alias_completion.bash

# Define prompt
# bpr="$RUNCOM2_ICON "
# bpr+="\[$IRed\]\u\[$CReset\]"
# bpr+="\[$IBlack\]@\[$CReset\]"
# bpr+="\[$IGreen\]\h\[$CReset\]"
# bpr+=" \[$IBlack\]\[$CReset\] "
# export PS1=$bpr
# unset bpr

source "$HOME/.homesick/repos/dotfiles/getaround.sh"
source "$HOME/.homesick/repos/dotfiles/aliases"
source "$HOME/.homesick/repos/dotfiles/functions"
source "$HOME/.homesick/repos/dotfiles/rc.common"

if command_exists starship; then
  eval "$(starship init bash)"
fi

# Deduplicate PATH
# dedup_pathvar PATH
