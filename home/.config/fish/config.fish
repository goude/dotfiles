# ---------- Early exits / guards ----------

# Only interactive shells should run UI / prompt / tool init
status --is-interactive; or return

# ---------- Environment ----------

set -gx HOMESHICK_REPOS $HOME/.homesick/repos

# ---------- Keybindings ----------

fish_vi_key_bindings
# theme_gruvbox dark medium

# ---------- Prompt ----------

if type -q starship
    starship init fish --print-full-init \
        | sed 's/"$(commandline)"/(commandline | string collect)/' \
        | source
end

# ---------- Homeshick ----------

if test -d $HOMESHICK_REPOS
    source $HOMESHICK_REPOS/homeshick/homeshick.fish 2>/dev/null
    source $HOMESHICK_REPOS/homeshick/completions/homeshick.fish 2>/dev/null
    source $HOMESHICK_REPOS/dotfiles/aliases 2>/dev/null
end

# ---------- Custom ----------

if functions -q load_em
    load_em
end

# ---------- Homebrew ----------
# Homebrew (only if present)
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# set -g fish_user_paths /usr/local/opt/openjdk/bin $fish_user_paths
