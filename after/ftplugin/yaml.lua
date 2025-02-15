vim.opt_local.includeexpr = "substitute(v:fname,'^/','','')"
vim.b.autoformat_enabled = false

local cmp = require("cmp")
-- inspired by this example: https://github.com/hrsh7th/nvim-cmp/issues/666#issuecomment-1000925581
local sources = cmp.get_config().sources
if sources ~= nil then
  for i in ipairs(sources) do
    if sources[i].name == "buffer" then
      local yaml_keyword_pattern = require("config.cmp").keyword_pattern.yaml
      sources[i].option.keyword_pattern = yaml_keyword_pattern
      break
    end
  end
  cmp.setup.buffer({ sources = sources })
end
