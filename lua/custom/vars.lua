--[[
These custom variables allow me to easily tweak settings between my work and personal configs.
--]]

return {
  copilot_enabled = false,
  codeium_enabled = true,
  banned_formatters = {
    ts_ls = true,
    pylsp = true,
    lua_ls = true,
  },
  -- see examples here if you want to set this:
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#yamlls
  yaml_schemas = nil,
  gitlab_domains = {},
}
