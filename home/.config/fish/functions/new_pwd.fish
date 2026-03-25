function new_pwd --on-variable PWD --description 'Show NOTES preview on dir change'
    status --is-command-substitution; and return

    set -l dir (pwd)
    set -l now (date +%s)

    # Pick NOTES file if present
    set -l notes ""
    if test -f NOTES.md
        set notes NOTES.md
    else if test -f _NOTES.md
        set notes _NOTES.md
    else
        return
    end

    # State file per directory (hashed path)
    set -l key (string replace -a "/" "_" $dir)
    set -l statefile "/tmp/.fish_notes_$key"

    set -l last 0
    if test -f $statefile
        set last (cat $statefile)
    end

    # Only show if > 60s since last time in this dir
    if test (math "$now - $last") -le 60
        return
    end

    echo $now >$statefile

    # Staleness warning — nudge if NOTES.md hasn't been touched in over a week
    set -l mtime (stat -c %Y $notes 2>/dev/null; or stat -f %m $notes 2>/dev/null)
    if test -n "$mtime"
        set -l age (math "$now - $mtime")
        if test $age -gt 604800
            set -l days (math --scale=0 "$age / 86400")
            set_color ff8c00  # orange
            printf "📝 %s hasn't been updated in %s days — time for a review?\n" $notes $days
            set_color normal
        end
    end

    # Pick viewer
    if type -q bat
        bat --style=plain --color=always --line-range :10 $notes
    else if type -q batcat
        batcat --style=plain --color=always --line-range :10 $notes
    else
        head -n 10 $notes
    end
end