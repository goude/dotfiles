-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "Dockerfile" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Group helper
local function augroup(name)
  return vim.api.nvim_create_augroup("local_" .. name, { clear = true })
end

-- When we come back to Neovim or switch buffers, check if files changed.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    -- Skip special buffers / command-line window
    if vim.bo.buftype ~= "" or vim.fn.getcmdwintype() ~= "" then
      return
    end
    vim.cmd.checktime()
  end,
})
