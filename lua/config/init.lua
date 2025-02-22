--[[
These custom variables allow me to easily tweak settings between my work and personal configs.
--]]

return {
  ai = {
    copilot_enabled = false,
    codeium_enabled = false,
    supermaven_enabled = true,
  },
  formatting = {
    on_save = true,
    ignored_files = {
      ["lazy-lock.json"] = true,
    },
  },
  -- see examples here if you want to set this:
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#yamlls
  yaml_schemas = nil,
}
