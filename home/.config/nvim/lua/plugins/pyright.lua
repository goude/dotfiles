local uv = vim.loop

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local project_root = config.root_dir
            local venv_python = project_root .. "/.venv/bin/python"

            -- Check if .venv/bin/python exists
            local stat = uv.fs_stat(venv_python)
            if stat and stat.type == "file" then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv_python
              vim.notify("Pyright: using local .venv -> " .. venv_python)
            else
              -- Optional fallback to uv-managed python
              local handle = io.popen("uv run which python 2>/dev/null")
              if handle then
                local path = handle:read("*a"):gsub("%s+$", "")
                handle:close()
                if path ~= "" then
                  config.settings = config.settings or {}
                  config.settings.python = config.settings.python or {}
                  config.settings.python.pythonPath = path
                  vim.notify("Pyright: using uv python -> " .. path)
                end
              end
            end
          end,

          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly", -- or "workspace"
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
      },
    },
  },
}
