# Kitty — route interactive ssh through `kitten ssh`, which copies xterm-kitty
# terminfo (and shell integration) to the remote on connect. Without it, remote
# curses programs warn "Could not set up terminal" and fall back to
# xterm-256color, losing kitty-specific capabilities.
#
# Ghostty solves the same problem itself via
# shell-integration-features = ssh-env,ssh-terminfo (see ~/.config/ghostty/base.conf);
# kitty has no such config flag, so the wrapper command is the supported path:
# https://sw.kovidgoyal.net/kitty/kittens/ssh/
#
# Guarded like conf.d/zellij.fish: only a real local kitty, never over SSH (where
# $TERM is already remapped and re-wrapping would be wrong). The alias is a fish
# function, so it only shadows ssh that *you* type interactively — git, rsync -e
# ssh, and scp exec /usr/bin/ssh directly and are untouched.
if not set -q SSH_TTY; and string match -q 'xterm-kitty' $TERM; and type -q kitten
    alias ssh="kitten ssh"
end
