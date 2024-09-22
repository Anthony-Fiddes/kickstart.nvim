--[[
These custom globals allow me to easily tweak settings between my work and personal configs.
--]]

vim.g.copilot_enabled = false
vim.g.codeium_enabled = true

vim.g.banned_formatters = {
  ts_ls = true,
  pylsp = true,
  lua_ls = true,
}
