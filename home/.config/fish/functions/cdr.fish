function cdr
    set -l root (git rev-parse --show-toplevel)
    or begin
        echo "not in a git repo"
        return 1
    end
    cd $root
end
