# TODO

- [ ] Refactor and reevaluate this backlog - based on recent changes and deletions
- [ ] create a justfile task to search for stale symlinks pointing to this repo, and deleting those links

Suggested improvements for the dotfiles repository.

## Setup & Installation

- [ ] Add an install script entry point (`setup/install.sh`) that orchestrates all install scripts in order
- [ ] Pin tool versions in `binary-tools-install.sh` (shfmt is pinned but starship and rust-analyzer pull latest)
- [ ] Update NVM version in `nvm-install.sh` (currently v0.39.2, latest is v0.40+)
- [ ] Add macOS support to `setup/base.yml` (currently Debian/Ubuntu only)
- [ ] Add a `Makefile` or `justfile` at the repo root for common tasks (install, link, lint, update)

## Shell Configuration

- [ ] Consolidate `rc.bash` and `rc.zsh` — they are nearly identical and could share more logic via `rc.common`
- [ ] Move `getaround.sh` sourcing into `rc.common` to reduce duplication
- [ ] Add shell startup time profiling (e.g. `time zsh -i -c exit`) to catch regressions
- [ ] Remove or update Fasd integration — Fasd is unmaintained; consider zoxide as a replacement

## Fish Shell

- [ ] Update Fisher plugins list — review for deprecated or replaced plugins
- [ ] Remove the Starship `sed` workaround if running fish 3.4+
- [ ] Sync fish functions with bash/zsh equivalents where possible (e.g. `fixssh`)

## Neovim

- [ ] Audit `lua/plugins/main.lua` for unused or superseded plugins
- [ ] Add a health check command or document expected LSP servers
- [ ] Consider consolidating `disable_nvim_r.lua` and similar one-off overrides

## Bin Scripts

- [ ] Add `--help` flags to scripts that lack them (e.g. `rcg`, `https2gitgithub`)
- [ ] Add shellcheck CI or pre-commit hook for `home/bin/` scripts
- [ ] Review `dip` and `fig` — large vendored scripts that may have upstream updates

## Terminal & Theming

- [ ] Unify color scheme configuration — Gruvbox is used in most places but Catppuccin appears in fish plugins
- [ ] Document Ghostty shader setup and overlay system in README or doc/
- [ ] Archive unused Kitty configs from `quarantine/` or remove them

## Quarantine

- [ ] Review quarantine directory for anything worth reviving or permanently removing
- [ ] The vendored `todo.sh` (1400+ lines) could be replaced with a package-managed version

## Documentation

- [ ] Expand README.md with a quick-start guide and repo structure overview
- [ ] Document the Homeshick workflow (clone, link, refresh)
- [ ] Add a screenshot or terminal recording showing the setup in action

## CI / Quality

- [ ] Add a GitHub Actions workflow for linting (shellcheck, shfmt, yamllint)
- [ ] Add an Ansible syntax check for `setup/base.yml`
- [ ] Add editorconfig validation
