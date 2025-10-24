function afs_stuff --on-variable PWD --description 'Do afs stuff'
    status --is-command-substitution; and return

    # If in home directory, run gm
    #if test (pwd) = $HOME
    #    gm
    #end

    # Show todo.txt if present
    if test -e todo.txt
        cat todo.txt
    end
end
