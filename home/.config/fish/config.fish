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

# ---------- Secrets ----------

set -l _secrets "$HOME/.secrets"
if test -f $_secrets
    set -l _perms (stat -c '%a' $_secrets 2>/dev/null; or stat -f '%OLp' $_secrets 2>/dev/null)
    if test "$_perms" != "600"
        echo "WARNING: $_secrets has permissions $_perms (expected 600). Skipping." >&2
    else
        while read -l _line
            switch $_line
                case 'op_secret *'
                    set -l _parts (string split ' ' -- $_line)
                    set -l _var $_parts[2]
                    set -l _ref (string trim -c '"' -- $_parts[3])
                    op_secret $_var $_ref
                case 'export *'
                    set -l _assign (string replace -r '^export ' '' -- $_line)
                    set -l _kv (string split -m 1 '=' -- $_assign)
                    if test (count $_kv) -eq 2
                        set -gx $_kv[1] (string trim -c '"' -- $_kv[2])
                    end
            end
        end < $_secrets
    end
end
set -e _secrets _perms

# ---------- Custom ----------

if functions -q load_em
    load_em
end

# ---------- Homebrew ----------
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# set -g fish_user_paths /usr/local/opt/openjdk/bin $fish_user_paths
