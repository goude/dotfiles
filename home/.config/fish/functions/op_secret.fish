function op_secret --description 'Load secret from 1Password into env, or skip silently'
    set -l var $argv[1]
    set -l ref $argv[2]
    if command -q op; and op account list >/dev/null 2>&1
        set -l val (op read $ref 2>/dev/null)
        if test $status -eq 0; and test -n "$val"
            set -gx $var $val
            return 0
        end
        echo "WARNING: could not read $var from 1Password ($ref)" >&2
    end
end
