# PATH — fish is the first-class shell, so it owns its own PATH setup
# rather than relying on rc.common (which serves bash/zsh). Mirrors:
#   rc.common: export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
#
# Without this, a fish login shell (e.g. SSH'd into Linux where fish is the
# login shell) never sees ~/bin, so tools installed there — notably starship
# (setup/tools.sh installs it to ~/bin) — are invisible and the starship
# prompt block in config.fish is silently skipped.
#
# fish_add_path is idempotent. -g keeps it session-global (driven entirely by
# this committed config, reproducible across machines, no per-host universal
# vars) and -p prepends in the given order.
fish_add_path -gp $HOME/bin $HOME/.local/bin
