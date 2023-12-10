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
