# nvim plugin archive

Disabled / experimental LazyVim plugin specs, parked **outside** `home/` so
homeshick never symlinks them into `~/.config/nvim`. They are kept for
reference, not loaded.

They used to live at `home/.config/nvim/lua/plugins/disabled/`. lazy.nvim's
`{ import = "plugins" }` does not recurse into subdirectories, so that folder
was already inert — but keeping inert specs *under* the linked config tree
left stale symlinks in `~` and cluttered the live config. Moving them here
keeps the active config lean.

To re-enable one: copy it up into `home/.config/nvim/lua/plugins/`, then run
`homeshick link dotfiles`.
