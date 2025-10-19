-- https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-10178217
-- This below is mainly to get rid of the annoying line length warning in markdown files
local HOME = os.getenv("HOME")
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = {
    linters = {
      ["markdownlint-cli2"] = {
        args = { "--config", HOME .. "/.markdownlint-cli2.yaml", "--" },
      },
    },
  },
}
