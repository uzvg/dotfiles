-- rime_ascii.lua
-- Neovim 自动切换 ibus-rime ascii_mode 插件

local DEST = "com.github.rime.ibus.Rime"
local PATH = "/com/github/rime/ibus/Rime"
local IFACE = "com.github.rime.ibus.Rime.AsciiMode"

-- insert 模式下用户想要的状态
local insert_ascii_mode = true

-- 调用 shell 命令
local function system(cmd)
  local ok, out = pcall(vim.fn.system, cmd)
  if not ok or vim.v.shell_error ~= 0 then
    return nil
  end
  return out
end

-- 解析 gdbus tuple 输出为 boolean
local function parse_gdbus_bool_tuple(out)
  if not out then return nil end
  out = out:gsub("%s+", "")  -- 去掉空格
  local b = out:match("^%((true)%)$") or out:match("^%((true),")
  if b then return true end
  b = out:match("^%((false)%)$") or out:match("^%((false),")
  if b then return false end
  return nil
end

-- 获取当前 ascii mode
local function get_ascii()
  local out = system({
    "gdbus", "call", "--session",
    "--dest", DEST,
    "--object-path", PATH,
    "--method", IFACE .. ".GetAsciiMode",
  })
  return parse_gdbus_bool_tuple(out)
end

-- 设置 ascii mode
local function set_ascii(v)
  system({
    "gdbus", "call", "--session",
    "--dest", DEST,
    "--object-path", PATH,
    "--method", IFACE .. ".SetAsciiMode",
    v and "true" or "false",
  })
end

-- InsertLeave: 保存 insert 状态，并保证 normal 模式 ascii
local function on_insert_leave()
  local cur = get_ascii()
  if cur == nil then return end
  insert_ascii_mode = cur
  if not cur then set_ascii(true) end
end

-- InsertEnter: 恢复 insert 时用户想要的状态
local function on_insert_enter()
  local cur = get_ascii()
  if cur == nil then return end
  if cur ~= insert_ascii_mode then
    set_ascii(insert_ascii_mode)
  end
end

-- 注册 autocmd
local group = vim.api.nvim_create_augroup("RimeAsciiAutoSwitch", { clear = true })

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = on_insert_leave,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = group,
  callback = on_insert_enter,
})
