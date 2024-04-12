-- Softwrapping .txt files just makes sense to me for writing emails and other
-- text where I want to paste it elsewhere.
vim.opt_local.formatoptions:remove("t")
vim.opt_local.linebreak = true

vim.opt_local.tabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 0
vim.opt_local.spell = true

local dont_zen_names = { "requirements", "requirements3" }
local zen = true
for _, name in ipairs(dont_zen_names) do
  if vim.fn.expand("%:r") == name then
    zen = false
    break
  end
end
-- for some reason the autocmd is required, calling the lua function puts my
-- cursor in the wrong place.
if zen then
  vim.cmd("autocmd VimEnter *.txt ZenMode")
end
