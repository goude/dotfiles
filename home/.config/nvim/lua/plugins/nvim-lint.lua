-- https://github.com/LazyVim/LazyVim/discussions/4094#discussioncomment-10178217
-- This below is mainly to get rid of the annoying line length warning in markdown files
-- Still broken however...
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

    -- attempting to turn of markdownlint by forcing use of markdownlint-cli2
    linters_by_ft = {
      markdown = { "markdownlint-cli2" },
      ["markdown.mdx"] = { "markdownlint-cli2" },
    },
  },
}
