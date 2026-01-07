require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "Q", "<CMD>q<CR>", { desc = "Quit the editor" })
map("n", "S", "<CMD>wq<CR>", { desc = "Save and quit the editor" })
-- vim.keymap.set('n', 'Q', '<cmd>q<CR>')

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
