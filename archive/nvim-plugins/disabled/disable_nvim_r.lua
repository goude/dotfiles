-- lua/plugins/disable_nvim_r.lua
-- This is a monkey patch to get rid of a message when enabling R support
-- in lazy vim. This can be removed later on.
-- The error was "you can't have Nvim-R and r.nvim enabled at the same time"
-- or something to that effect...
return {
  {
    "jalvesaq/Nvim-R",
    enabled = false,
  },
}
