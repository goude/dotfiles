function save --description 'Quick git save'
    if count $argv > /dev/null
        git commit -a -m "$argv[1]"
        git push
    else
        echo "Missing commit message"
        return 1
    end
end
