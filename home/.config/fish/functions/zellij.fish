# Bare `zellij` attaches to (or creates) a session named after this host,
# so the terminal title reads "Zellij (zelda)" instead of a random name like
# "Zellij (charming-capsicum)" — makes nested ssh sessions distinguishable.
# Any arguments bypass the wrapper, so `zellij -s foo`, `zellij ls`, etc.
# behave as usual.
function zellij --wraps zellij --description 'zellij, defaulting to a hostname-named session'
    if test (count $argv) -eq 0
        command zellij attach --create (hostname -s)
    else
        command zellij $argv
    end
end
