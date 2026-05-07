require("nvchad.configs.lspconfig").defaults()
-- 🔗 https://nvchad.com/docs/recipes
local servers = {
  html = {},
  cssls = {},
  lua_ls = {},
  pyright = {},
  markdown_oxide = {},
  bashls = {
    filetypes = { "bash", "sh", "zsh" },
  },
}

for name, opts in pairs(servers) do
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

-- read :h vim.lsp.config for changing options of lsp servers
