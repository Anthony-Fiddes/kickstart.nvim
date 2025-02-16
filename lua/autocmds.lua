-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

local augroup = vim.api.nvim_create_augroup("custom_settings", { clear = true })
-- Set tab defaults for new text files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.txt", "*.md" },
  group = augroup,
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 0
  end,
})

-- Set tab defaults for new go files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.go" },
  group = augroup,
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 0
  end,
})

-- Use modelines for help files to correctly set filetype
vim.api.nvim_create_autocmd("BufReadPre", {
  pattern = { "*/doc/*.txt" },
  group = augroup,
  callback = function()
    vim.opt_local.modelines = 5
  end,
})
