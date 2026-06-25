-- Active custom plugin specs live in this directory (lua/plugins/*.lua).
-- lazy.nvim's `{ import = "plugins" }` (see config/lazy.lua) loads every
-- top-level file here. It does NOT recurse, so lua/plugins/disabled/ is an
-- inert archive — move a file up one level to re-enable it.
--
-- This stub keeps the import resolvable while the config stays lean. Without
-- at least one real top-level spec, lazy throws "No specs found for module
-- plugins" on every startup (an empty `{}` does not count). The bare reference
-- below merges into the snacks.nvim spec LazyVim already loads, so it changes
-- nothing — it just gives the import something to find. Add your own specs
-- here; this file can go once another real one exists.
return {
  "folke/snacks.nvim",
}
