# ~/.config/fish/functions/yo.fish
# Context-aware micro-hints for Fish shell

# ── State ──────────────────────────────────────────────────
function __yo_state_dir
    set -l dir ~/.local/state/yo
    test -d $dir; or mkdir -p $dir
    echo $dir
end

function __yo_state_get -a key
    set -l file (__yo_state_dir)/$key
    test -f $file; and cat $file
end

function __yo_state_set -a key value
    echo $value >(__yo_state_dir)/$key
end

function __yo_once_today -a key
    set -l full_key "{$key}_"(date +%Y-%m-%d)
    test "(__yo_state_get $full_key)" = 1; and return 1
    __yo_state_set $full_key 1
end

# ── Context helpers ────────────────────────────────────────
function __yo_git_root
    command git rev-parse --show-toplevel 2>/dev/null
end

function __yo_is_git_root
    set -l root (__yo_git_root)
    test -n "$root" -a "$PWD" = "$root"
end

function __yo_dir_depth
    set -l rel (string replace -r "^$HOME" "" $PWD)
    string split / $rel | count
end

# ── Hint definitions ───────────────────────────────────────
# Each appends to __yo_hints if triggered. Add new hints as __yo_hint_* functions.

function __yo_hint_deep_nesting
    test (__yo_dir_depth) -ge 4; or return
    set -a __yo_hints "cdr gets you back to the top of the repo"
end

function __yo_hint_git_root
    __yo_is_git_root; or return
    __yo_once_today gitroot; or return
    set -a __yo_hints "chk gives helpful repo diagnostics"
end

function __yo_hint_thx_oclock
    test (date +%H:%M) = "11:38"; or return
    __yo_once_today thx; or return
    set -a __yo_hints "It's THX o'clock 🔊"
end

function __yo_hint_hourly_chime
    test (date +%M) = 00; or return
    set -l hour (date +%H)
    __yo_once_today "hour_$hour"; or return
    set -a __yo_hints "It's $hour:00."
end

# ── Hint runner ────────────────────────────────────────────
function __yo_collect_hints
    set -g __yo_hints
    for fn in (functions -n | string match '__yo_hint_*')
        $fn
    end
end

function __yo_show_hints
    __yo_collect_hints
    test (count $__yo_hints) -gt 0; or return 1
    set_color brblack
    printf "💡 %s\n" $__yo_hints
    set_color normal
end

# ── Triggers ───────────────────────────────────────────────
function yo_hints --on-event fish_postexec
    set -l cmd (string split " " $argv)[1]
    test "$cmd" = yo; and return
    set -q __yo_cmd_count; or set -g __yo_cmd_count 0
    set -g __yo_cmd_count (math $__yo_cmd_count + 1)
    test (math $__yo_cmd_count % 10) -eq 0; and __yo_show_hints
end

function yo
    switch "$argv[1]"
        case -h --help
            echo "yo - context-aware hints"
            echo
            echo "Usage:"
            echo "  yo        show relevant hints"
            echo "  yo --help this help"
            echo
            echo "Hints fire passively every 10 commands."
            echo "State: ~/.local/state/yo/"
        case '*'
            __yo_show_hints; or begin
                set_color brblack
                echo "🤷 no hints right now"
                set_color normal
            end
    end
end
