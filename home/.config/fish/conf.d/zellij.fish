# Zellij — pick keybinding scheme by context.
#
# An outer (local) zellij consumes Ctrl Super / Ctrl Alt / Alt chords before
# they reach an SSH pane, and browser terminals (xterm.js) never forward
# Super and steal most Ctrl+letter chords. So zellij sessions started over
# SSH use a tmux-style prefix scheme (Ctrl b + plain letters) that survives
# nesting, SSH, and the browser — see config-ssh.kdl.
#
# SSH_TTY is only set in sshd-spawned sessions; the zellij server inherits
# the env it was started with, so panes inside a remote session keep using
# the SSH config. Local sessions (Ghostty on the mac, console on Linux) fall
# through to the default config.kdl with the Ctrl Super / Alt scheme.
if set -q SSH_TTY
    set -gx ZELLIJ_CONFIG_FILE ~/.config/zellij/config-ssh.kdl
end
