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
vim.o.sessionoptions = "curdir,folds,tabpages,winpos,winsize"

-- Wrapping text as I type is more often annoying than helpful in code. It's
-- welcome in comments.
vim.opt.formatoptions:remove("t")

-- Preview substitutions as I type
vim.opt.inccommand = "split"

vim.opt.spelllang:append("de_de")

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
  },
})

-- Set tab defaults for new text files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.txt", "*.md" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 0
  end,
})

-- Set tab defaults for new go files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.go" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.expandtab = false
    vim.opt_local.shiftwidth = 0
  end,
})
