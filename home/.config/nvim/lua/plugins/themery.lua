-- ~/.config/nvim/lua/plugins/themery.lua
return {
  "zaldih/themery.nvim",
  lazy = false,
  opts = {
    themes = {
      {
        name = "Gruvbox dark",
        colorscheme = "gruvbox",
      },
      {
        name = "Gruvbox light",
        colorscheme = "gruvbox",
        before = [[ vim.opt.background = "light" ]],
      },
      "tokyonight",
      "catppuccin",
      "gruvbox",
    },
    globalBefore = [[ vim.opt.background = "dark" ]],
    livePreview = true,
  },
  keys = {
    { "<leader>tc", "<cmd>Themery<cr>", desc = "Pick theme" },
    {
      "<leader>tn",
      function()
        require("themery").setThemeByIndex((require("themery").getCurrentTheme() or { index = 0 }).index + 1, true)
      end,
      desc = "Next theme",
    },
    {
      "<leader>tp",
      function()
        require("themery").setThemeByIndex((require("themery").getCurrentTheme() or { index = 2 }).index - 1, true)
      end,
      desc = "Prev theme",
    },
  },
}
