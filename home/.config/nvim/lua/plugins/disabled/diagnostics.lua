-- ~/.config/nvim/lua/plugins/diagnostics.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      -- inline virtual text: short + show source
      virtual_text = {
        source = "always", -- show [mypy], [pyright], [ruff], etc.
        -- optional: shorten message a bit
        format = function(d)
          -- show first sentence only, tweak as you like
          local msg = d.message:gsub("%s+", " ")
          msg = msg:gsub("%. .*", ".")
          return string.format("[%s] %s", d.source or "LSP", msg)
        end,
      },
      -- floating window (hover) diagnostics
      float = {
        source = "always",
        border = "rounded",
        max_width = 80,
      },
      underline = true,
      signs = true,
      update_in_insert = false,
    },
  },
}
