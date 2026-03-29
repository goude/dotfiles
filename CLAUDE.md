## Session Discipline

- Never write >150 lines in a single tool call
- For files >100 lines: create skeleton first, fill sections in subsequent edits
- Never retry a timed-out operation identically — break it smaller
- On interrupt: stop immediately, commit partial work, then reassess
- After any file edit, re-read before editing again (stale context kills diffs)

## Ownership

- `setup/` — setup scripts; each file is one concern (packages, python, node, etc.)
- `setup/lib.sh` — shared helpers; all other setup scripts source this
- `home/` — homeshick-managed dotfiles (symlinked into `~`)
- `home/.config/nvim/` — LazyVim configuration
- `home/.config/fish/` — fish shell config and functions
- `home/.config/ghostty/` — Ghostty terminal config + shaders
- `rc.common`, `rc.bash`, `rc.zsh` — shell init; `rc.common` is the shared core
- `getaround.sh` — shell framework (EDITOR, keybindings, helpers)
- `aliases`, `functions` — shell aliases and functions
- `docs/` — documentation and backlog
- `docs/standards/` — project standards (justfile, python, etc.)

## Boundaries

This is a dotfiles repo — flat structure, no deep module hierarchy.
Key rule: setup scripts must not modify files under `home/` (that's homeshick's job).

## Before Finishing

Run `just lint` if shell scripts were modified.
Verify `just` (bare) still produces a clean list.

## Reference

- Standards: `docs/standards/`
- Backlog: `docs/backlog.md`
