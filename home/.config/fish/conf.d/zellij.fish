# Zellij — pick the keybinding scheme by terminal capability.
#
# The rich scheme (config.kdl) drives modes with Ctrl+Super and navigation with
# Ctrl+Alt. Those chords only survive where the Kitty keyboard protocol is live:
# a local kitty or ghostty terminal on Linux. Everywhere else they break —
# macOS (Cmd hijacked), Windows (Ctrl+Alt = AltGr), SSH/browser (no Super) — so
# fall back to the portable Ctrl-a prefix scheme (config-portable.kdl), which is
# also what an inner session uses when nesting under a local zellij.
#
# Both branches set ZELLIJ_CONFIG_FILE explicitly, so there is no fragile
# reliance on the bare-default config path.
if not set -q SSH_TTY; and test (uname) = Linux; and string match -qr '^xterm-(kitty|ghostty)$' $TERM
    set -gx ZELLIJ_CONFIG_FILE ~/.config/zellij/config.kdl
else
    set -gx ZELLIJ_CONFIG_FILE ~/.config/zellij/config-portable.kdl
end
