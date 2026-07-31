require("nvchad.mappings")
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "Q", ":exit<CR>", { desc = "Exit neovim" })
map("n", "<leader>q", ":exit<CR>", { desc = "Exit neovim" })
-- map("n", "S", ":w<CR>", { desc = "Save Changes" })

-- 只有 y 和 d 允许触碰系统剪贴板
map({ "n", "v" }, "y", '"+y')
map("n", "yy", '"+yy')
map("n", "Y", '"+Y')

map({ "n", "v" }, "d", '"+d')
map("n", "dd", '"+dd')
map("n", "D", '"+D')

-- x, s, c, C 统统送进黑洞寄存器
map({ "n", "v" }, "x", '"_x')
map({ "n", "v" }, "s", '"_s')
map({ "n", "v" }, "c", '"_c')
map("n", "C", '"_C')
map("n", "S", '"_S')

-- 普通模式直接粘，可视模式替换但不覆盖剪贴板
map("n", "p", '"+p')
map("n", "P", '"+P')
map("v", "p", '"+P') -- 关键：可视模式用大写 P 的行为实现小写 p 的功能

-- 如果 count 为 0 执行 gj/gk，否则执行 j/k
map({ "n", "x", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Move cursor down" })
map({ "n", "x", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Move cursor up" })

-- Execute lua code
map("n", "<space>rc", "<cmd>source %<cr>", { desc = "Source current file" })
map("n", "<space>rl", ":.lua<cr>", { desc = "Execute current line" })
map("v", "<space>rs", ":lua<cr>", { desc = "Execute selection" })

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- editing neovim config
map("n", "<leader>nc", function()
	local config_path = vim.fn.stdpath("config")
	local nvim_tree_api = require("nvim-tree.api")
	nvim_tree_api.tree.open({ path = config_path, find_file = true })
	print("Navigate to nvim config dir: " .. config_path)
end, { desc = "Edit Neovim Config (NvimTree)" })
