local cmp = require("cmp")

local buffer_source = {
  name = "buffer",
  option = {
    -- use all visible buffers
    get_bufnrs = function()
      local bufs = {}
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        bufs[vim.api.nvim_win_get_buf(win)] = true
      end
      return vim.tbl_keys(bufs)
    end,
  },
}
-- if a yaml file is mentioned in the git commit diff, use my custom
-- special keyword_pattern for yaml so that long job
-- names with ':' are properly autocompleted.
--
-- It may be a bit overcomplicated, but it's fun :)
local yaml_present = vim.fn.search([[\(yaml\|yml\)]], "nw") ~= 0
if yaml_present then
  local yaml_keyword_pattern = require("config").cmp.keyword_pattern.yaml
  local new_option = {
    keyword_pattern = yaml_keyword_pattern,
  }
  buffer_source.option = vim.tbl_deep_extend("force", buffer_source.option, new_option)
end

cmp.setup.buffer({
  sources = cmp.config.sources({
    { name = "conventionalcommits" },
    buffer_source,
    { name = "luasnip" },
    { name = "copilot" },
    { name = "codeium" },
  }),
})
