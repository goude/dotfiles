function git --description 'Git wrapper with checkout guard' --wraps git
    if test "$argv[1]" = checkout
        echo "Use 'git switch' (branches) or 'git restore' (files). [fish muscle memory reminder]" >&2
        return 1
    end
    command git $argv
end
