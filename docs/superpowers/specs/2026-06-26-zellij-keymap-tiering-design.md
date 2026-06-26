# Zellij keymap tiering — design

Date: 2026-06-26

## Problem

One zellij keymap can't be both rich and portable. The ingrained local scheme
leans on **Ctrl+Super** (mode switches) and **Ctrl+Alt** (navigation), but those
are exactly the chords that don't survive across Daniel's machines:

- **macOS** — Super = Cmd, hijacked by the OS/terminal.
- **Windows** (ingvild, later) — Ctrl+Alt = AltGr, eaten by the IME.
- **SSH / browser** — Super never transmits; browser steals many Ctrl chords.

Ctrl+Super and Ctrl+Alt only work where the [Kitty keyboard protocol](https://sw.kovidgoyal.net/kitty/keyboard-protocol/)
is live end-to-end — i.e. a local **kitty or ghostty** terminal on Linux.

## Decision

Tier the keymap by terminal capability, not by SSH alone. Two schemes, selected
automatically:

| Scheme | File | Keys | Used when |
|---|---|---|---|
| **rich** | `config.kdl` | Ctrl+Super modes, Ctrl+Alt nav, plain Alt free for the shell | local + Linux + kitty/ghostty |
| **portable** | `config-portable.kdl` | Ctrl-a tmux-style prefix | everywhere else: macOS, Windows, SSH, browser, plain tty |

Nesting still works: an outer rich session keeps Ctrl+Super/Ctrl+Alt and passes
Ctrl-a through to an inner portable session.

## Selector — `conf.d/zellij.fish`

```fish
if not set -q SSH_TTY; and test (uname) = Linux; and string match -qr '^xterm-(kitty|ghostty)$' $TERM
    set -gx ZELLIJ_CONFIG_FILE ~/.config/zellij/config.kdl          # rich
else
    set -gx ZELLIJ_CONFIG_FILE ~/.config/zellij/config-portable.kdl # prefix
end
```

Both branches set the path explicitly — no reliance on a bare default.

## Constraints honoured

- **Minimal code.** `config.kdl` becomes *additive* (drop `clear-defaults`): it
  inherits zellij's defaults and declares only the deltas — free the Ctrl+letter
  mode chords, free plain Alt in normal mode, add the Ctrl+Super and Ctrl+Alt
  layers, override rename-to-empty, add `| -` splits in tmux mode. ~50 lines of
  keybinds instead of a 300-line clone.
- **Keystrokes unchanged on laszlo.** Every Ctrl+Super / Ctrl+Alt combo in use
  today is preserved verbatim.
- **Color = scheme.** Orange ribbon = rich, blue ribbon = portable, so tab
  colour tells you which keymap is live on any box.

## Out of scope

- Windows predicate is approximate until ingvild is real (WSL reports Linux; but
  no kitty/ghostty `TERM` there yet, so it lands on portable — correct for now).
- tmux is archived (`attic/`), not part of this scheme.
