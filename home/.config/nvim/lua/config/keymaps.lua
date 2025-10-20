-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Disabled - I do not remeber why I set them from the start because they were disabling the nifty up/down line moves
-- vim.keymap.set("i", "<M-j>", "j")
-- vim.keymap.set("i", "<M-k>", "k")
-- vim.keymap.set("n", "<M-j>", "j")
-- vim.keymap.set("n", "<M-k>", "k")
--

vim.keymap.set("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  print("Diagnostics " .. (vim.diagnostic.is_enabled() and "enabled" or "disabled"))
end, { desc = "Toggle diagnostics" })
