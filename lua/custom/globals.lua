--[[
These custom globals allow me to easily tweak settings between my work and personal configs.
--]]

vim.g.copilot_enabled = false

vim.g.banned_formatters = {
  tsserver = true,
  pylsp = true,
  lua_ls = true,
}
