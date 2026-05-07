require "nvchad.mappings"
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "Q", ":exit<CR>", { desc = "Exit neovim" })
map("n", "qq", ":exit<CR>", { desc = "Exit neovim" })
map("n", "S", ":w<CR>", { desc = "Save Changes" })

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

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
