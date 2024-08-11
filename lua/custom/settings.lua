-- I can't live in a world with 8 wide tabs
vim.o.tabstop = 4

-- Don't let Vim do unsafe stuff
vim.o.modelines = 0

-- See whitespace when list is on
vim.o.listchars = "tab:> ,trail:⋅,extends:>,precedes:<"

-- Hard wrap text at this col
vim.o.textwidth = 80

-- Don't soft wrap lines in the middle of a word
vim.o.linebreak = true

-- Relative line numbers are fun
vim.wo.relativenumber = true

-- Important when using a session manager that loads/saves sessions
-- automatically
vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winpos,winsize"

-- Wrapping text as I type is more often annoying than helpful in code. It's
-- welcome in comments.
vim.opt.formatoptions:remove("t")

-- Preview substitutions as I type
vim.opt.inccommand = "split"

vim.opt.spelllang:append("de_de")

-- Set tab defaults for text files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.txt", "*.md" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 0
  end,
})

-- Set tab defaults for go
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 0
  end,
})
