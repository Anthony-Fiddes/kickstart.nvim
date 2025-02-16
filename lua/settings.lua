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
-- Highlight current line
vim.wo.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Important when using a session manager that loads/saves sessions
-- automatically
vim.o.sessionoptions = "curdir,folds,tabpages,winpos,winsize"

-- Wrapping text as I type is more often annoying than helpful in code. It's
-- welcome in comments.
vim.opt.formatoptions:remove("t")
-- Respect numbered list indentation
vim.opt_local.formatoptions:append("n")

-- Preview substitutions as I type
vim.opt.inccommand = "split"

vim.opt.spelllang:append("de_de")

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Split new windows to the right
vim.opt.splitright = true

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

-- mainly for gitsigns, so I can see staged vs unstaged content. Taken from:
-- https://github.com/lewis6991/gitsigns.nvim/issues/1102
vim.wo.signcolumn = "auto:1-2"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
-- this is available on systems that use my fish config, so we can use it
-- to get rid of the flicker of dark background I see when in light mode.
local system_theme = os.getenv("THEME")
if system_theme ~= nil then
  if system_theme == "dark" then
    vim.o.background = "dark"
  else
    vim.o.background = "light"
  end
end

-- mainly to make markdown prettier
vim.o.conceallevel = 2

-- use treesitter's folding capabilities
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- just show the code with highlighting
vim.opt.foldtext = ""
-- don't fold code by default, please
vim.opt.foldlevelstart = 99
-- don't add a bunch of dots after the foldtext...
vim.opt.fillchars = { fold = " " }

vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
  },
})
