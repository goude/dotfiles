# dotfiles

These are my dotfiles.

Primary terminal stack: **Ghostty + fish + zellij**.
Fish is the first-class interactive shell; all interactive config lives under
`home/.config/fish/`. The `rc.common` / `rc.bash` / `rc.zsh` files exist for
POSIX/bash compatibility but are secondary.

---

## Search tools (fd / rg)

Both tools are configured to behave well inside git repos where `.gitignore`
is often overly restrictive (generated configs, editor files, etc.).

### What's configured

| Setting | fd | rg |
|---|---|---|
| Include hidden files | `--hidden` | `--hidden` |
| Ignore VCS ignore rules | `--no-ignore-vcs` | `--no-ignore-vcs` |
| Exclude noise dirs | `--exclude <dir>` (× 6) | `--glob=!<dir>` (× 6) |

**Excluded dirs:** `node_modules`, `dist`, `.git`, `target`, `__pycache__`, `.cache`

**Why `--no-ignore-vcs`?** Inside a repo, generated configs, editor files, and
local build artifacts are often gitignored. Without this flag both tools silently
skip them, making searches feel broken. The explicit excludes above cover the dirs
you almost never want.

### Files

- `home/.config/fish/conf.d/search.fish` — sets `RIPGREP_CONFIG_PATH` and the
  `fd` alias.
- `home/.config/rg/config` — ripgrep flags, loaded automatically via
  `RIPGREP_CONFIG_PATH`.

### Temporarily overriding

```fish
# Nuclear: respect nothing, search everything
fd --no-ignore --no-ignore-vcs <pattern>
rg --no-ignore --no-ignore-vcs <pattern>

# Add back a single ignore file (e.g. a local .ignore)
fd --ignore-file .ignore <pattern>

# One-off: also search node_modules
fd --no-ignore-vcs <pattern>   # removes the alias excludes automatically
```

> `fd` alias flags are baked into the function; to skip the alias entirely use
> `command fd <args>`.

### Updating the exclude list

Edit both files together so they stay in sync:

1. `home/.config/fish/conf.d/search.fish` — add `--exclude <dir>` to the alias.
2. `home/.config/rg/config` — add `--glob=!<dir>`.
