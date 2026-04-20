require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- 将 tiddlywiki.info 识别为 json
autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "tiddlywiki.info",
  callback = function()
    vim.bo.filetype = "json"
  end,
})
