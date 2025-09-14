#!/usr/bin/env bash

source $HOME/.homesick/repos/runcom2/rc.common

#source $HOMESHICK_REPOS/homeshick/completions/homeshick-completion.bash
#source $RUNCOM2_PATH/utils/bash_colors

source $RUNCOM2_PATH/rc.common-post

# Workarounds
#source $RUNCOM2_PATH/utils/fix_alias_completion.bash

if command_exists starship; then
  eval "$(starship init zsh)"
fi

# Deduplicate PATH
dedup_pathvar PATH
