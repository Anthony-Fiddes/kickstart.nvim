local mini_misc = require("mini.misc")
mini_misc.safely("later", function()
  -- Enabling them to evaluate their utility
  vim.cmd("packadd nvim.undotree")
  vim.cmd("packadd nvim.difftool")
  vim.cmd("packadd nvim.tohtml")
end)
