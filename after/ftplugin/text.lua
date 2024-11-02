-- Softwrapping .txt files just makes sense to me for writing emails and other
-- text where I want to paste it elsewhere.
vim.opt_local.formatoptions:remove("t")
vim.opt_local.linebreak = true

vim.opt_local.spell = true

local dont_zen_names = { "requirements", "requirements3" }
local zen = true
for _, name in ipairs(dont_zen_names) do
  if vim.fn.expand("%:r") == name then
    zen = false
    break
  end
end

if zen then
  local zen_mode = require("zen-mode")
  local buf = vim.api.nvim_get_current_buf()
  local zen_text_augroup = vim.api.nvim_create_augroup("zen-text", { clear = true })
  -- the event has to be VimEnter, probably because it needs certain UI elements
  -- to be loaded.
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = zen_text_augroup,
    buffer = buf,
    callback = function()
      zen_mode.open()
    end,
  })
end
