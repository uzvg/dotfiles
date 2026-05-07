require "nvchad.mappings"
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "Q", ":exit<CR>", { desc = "Exit neovim" })
map("n", "qq", ":exit<CR>", { desc = "Exit neovim" })
map("n", "S", ":w<CR>", { desc = "Save Changes" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
