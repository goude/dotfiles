# Search tool defaults (fd + rg)
# See README.md § "Search tools (fd / rg)" for rationale.

# RIPGREP_CONFIG_PATH — picked up automatically by rg on every invocation
set -gx RIPGREP_CONFIG_PATH "$HOME/.config/rg/config"

# fd: hidden files, ignore VCS ignore rules, but skip common noise dirs
alias fd='fd --hidden --no-ignore-vcs --exclude node_modules --exclude dist --exclude .git --exclude target --exclude __pycache__ --exclude .cache'
