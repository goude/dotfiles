-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Fix problem with Esc triggering Alt+j, Alt+k behavior
-- https://www.johnhawthorn.com/2012/09/vi-escape-delays/
vim.opt.ttimeoutlen = 0

-- Disable unused language-host providers. Nothing in this config uses the
-- perl/ruby/python3 remote-plugin hosts, so turning them off silences the
-- :checkhealth provider warnings and trims a little startup work on every
-- machine. Re-enable a line if you ever add a plugin that needs that host.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
