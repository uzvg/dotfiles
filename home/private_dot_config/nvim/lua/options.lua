require "nvchad.options"

local o = vim.o

-- to enable cursorline!
-- o.cursorline = true
o.cursorlineopt ='both'

-- 开启 Tree-sitter 折叠
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- 默认不折叠（打开文件时所有代码都是展开的）
-- 如果设为 0，打开文件时所有代码都会折叠起来
vim.opt.foldlevel = 99
