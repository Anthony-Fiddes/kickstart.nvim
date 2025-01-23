--[[
These custom variables allow me to easily tweak settings between my work and personal configs.
--]]

return {
  copilot_enabled = false,
  codeium_enabled = false,
  formatting = {
    on_save = true,
    banned_lsps = {
      ts_ls = true,
      pylsp = true,
      lua_ls = true,
      gopls = true,
    },
    ignored_files = {
      ["lazy-lock.json"] = true,
    },
  },
  -- see examples here if you want to set this:
  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#yamlls
  yaml_schemas = nil,
  gitlab_domains = {},
  cmp = {
    keyword_pattern = {
      -- the newly added second group matches job names like `.cnf:example:` as
      -- `.cnf:example`
      yaml = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%([\-.\:]\w*\)*\ze\:\|\h\w*\%([\-.]\w*\)*\)]],
    },
  },
}
