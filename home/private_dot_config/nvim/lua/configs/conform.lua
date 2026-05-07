local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    zsh = { "shfmt" },
    css = { "prettier" },
    html = { "prettier" },
  },

  -- formatters = {
  --   shfmt = {
  --     -- -i 2 表示缩进为 2
  --     args = { "-i", "2", "-" },
  --   },
  -- },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
