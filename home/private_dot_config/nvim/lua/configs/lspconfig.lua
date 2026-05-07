require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "markdown_oxide", "lua_ls", "bashls", "pyright" }
-- local servers = { "html", "cssls" }

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
