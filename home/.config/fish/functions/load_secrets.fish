function load_secrets --description 'Load ~/.secrets into the environment'
    set -l _secrets "$HOME/.secrets"
    if not test -f $_secrets
        echo "No secrets file found at $_secrets" >&2
        return 1
    end
    set -l _perms (stat -c '%a' $_secrets 2>/dev/null; or stat -f '%OLp' $_secrets 2>/dev/null)
    if test "$_perms" != "600"
        echo "WARNING: $_secrets has permissions $_perms (expected 600). Skipping." >&2
        return 1
    end
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
    echo "Secrets loaded."
end
