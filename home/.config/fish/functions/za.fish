# Attach to the running zellij session if there's exactly one; create a new
# session if there are none. Refuse to guess when several are live — listing
# them so you can `zellij attach <name>` deliberately. Exited (resurrectable)
# sessions are ignored; only live ones count.
function za --description 'Attach to the lone zellij session, or create one; error if several'
    set -l sessions (zellij list-sessions -n 2>/dev/null | string match -v '*EXITED*' | string trim | string split ' ' -f1)

    switch (count $sessions)
        case 0
            command zellij attach --create (hostname -s)
        case 1
            command zellij attach $sessions[1]
        case '*'
            echo "za: multiple zellij sessions, attach by name:" >&2
            printf '  %s\n' $sessions >&2
            return 1
    end
end
