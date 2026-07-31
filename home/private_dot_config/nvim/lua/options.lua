require "nvchad.options"

local o = vim.o

-- to enable cursorline!
o.cursorline = true
o.cursorlineopt = "both"
o.foldenable = true

-- 开启 Tree-sitter 折叠
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- 默认不折叠（打开文件时所有代码都是展开的）
-- 如果设为 0，打开文件时所有代码都会折叠起来
vim.opt.foldlevel = 99

vim.opt.shiftwidth = 2 -- 缩进时缩进的空格数
vim.opt.tabstop = 2 -- 每一个制表符代表的空格数
vim.opt.softtabstop = 2 -- 敲击 Tab 键时插入的空格数
vim.opt.expandtab = true -- 将 Tab 转换为空格

-- vim.opt.column = "yes" -- 始终显示左侧列
-- vim.opt.foldcolumn = "1" -- 开启折叠列，否则折叠图标没地方显示
