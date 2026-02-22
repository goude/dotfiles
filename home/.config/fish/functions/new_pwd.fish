function new_pwd --on-variable PWD --description 'Show NOTES preview on dir change'
    status --is-command-substitution; and return

    set dir (pwd)
    set now (date +%s)

    # Pick NOTES file if present
    set notes ""
    if test -f NOTES.md
        set notes NOTES.md
    else if test -f _NOTES.md
        set notes _NOTES.md
    else
        return
    end

    # State file per directory (hashed path)
    set key (string replace -a "/" "_" $dir)
    set statefile "/tmp/.fish_notes_$key"

    set last 0
    if test -f $statefile
        set last (cat $statefile)
    end

    # Only show if > 60s since last time in this dir
    if test (math "$now - $last") -le 60
        return
    end

    echo $now > $statefile

    # Pick viewer
    if type -q bat
        bat --style=plain --color=always --line-range :10 $notes
    else if type -q batcat
        batcat --style=plain --color=always --line-range :10 $notes
    else
        head -n 10 $notes
    end
end