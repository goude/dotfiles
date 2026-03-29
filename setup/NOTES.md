# Setup

Run `just setup` after cloning. It runs each script in order:

1. **packages.sh** — system packages via apt (Linux/WSL) or brew (macOS)
2. **uv.sh** — Python via uv (currently 3.13)
3. **node.sh** — Node.js via nvm (currently 22)
4. **neovim.sh** — latest stable Neovim (platform-aware binary)
5. **tools.sh** — starship prompt, shfmt
6. **homeshick.sh** — clone and link dotfiles

Each script sources `lib.sh` for platform detection and helpers.
Scripts are idempotent — safe to re-run.

## Supported platforms

- Ubuntu LTS (server / desktop)
- Raspberry Pi 500 (aarch64)
- macOS (Homebrew)
- WSL2

## Starship

For now the fish init for starship uses a workaround (fish <3.4):

```bash
starship init fish --print-full-init | sed 's/"$(commandline)"/(commandline | string collect)/' | source
```

See: <https://github.com/starship/starship/issues/6336>

## Legacy

The `install/` subdirectory contains the previous setup scripts.
These will be removed once the new scripts are validated on all platforms.
