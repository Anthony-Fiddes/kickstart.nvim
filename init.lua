-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- generated_globals is optional
pcall(require, "custom.generated_globals")

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      sign_priority = 100,

      on_attach = function(bufnr)
        local function map(mode, lhs, rhs, desc, expr)
          if expr == nil then
            expr = false
          end
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, expr = expr })
        end

        local function update_after(callback)
          return function()
            callback()
            vim.cmd("update")
          end
        end

        local gs = package.loaded.gitsigns
        map("n", "<Leader>hb", function()
          gs.blame_line({ full = true })
        end, "[hb] Show git blame for hunk")
        map("n", "hp", gs.preview_hunk, "[H]unk [P]review")
        map({ "n", "v" }, "<Leader>hs", update_after(gs.stage_hunk), "[hs] Stage Hunk")
        map({ "n", "v" }, "<Leader>hS", update_after(gs.stage_buffer), "[hS] Stage Buffer")
        map({ "n", "v" }, "<Leader>hu", update_after(gs.undo_stage_hunk), "[hu] Undo Stage Hunk")
        map({ "n", "v" }, "<Leader>hr", update_after(gs.reset_hunk), "[hr] Reset Hunk")
        map({ "n", "v" }, "<Leader>hR", update_after(gs.reset_buffer), "[hR] Reset Buffer")
        map("n", "<Leader>tb", gs.toggle_current_line_blame, "[T]oggle git [blame] on current line")
        -- hunk text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

        local function next_hunk()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end
        map({ "n", "v" }, "<Leader>hn", next_hunk, "[hn] Jump to next hunk", true)
        map({ "n", "v" }, "]h", next_hunk, "[hn] Jump to next hunk", true)
        local function prev_hunk()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end
        map({ "n", "v" }, "<Leader>hN", prev_hunk, "[hN] Jump to previous hunk", true)
        map({ "n", "v" }, "[h", prev_hunk, "[hN] Jump to previous hunk", true)
      end,
    },
  },

  {
    -- Theme inspired by Atom
    "navarasu/onedark.nvim",
    priority = 1000,
    config = function()
      require("onedark").setup({
        style = "warmer",
      })
      require("onedark").load()
    end,
  },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = "onedark",
        component_separators = "|",
        section_separators = "",
      },
      sections = { lualine_c = { { "filename", path = 4 } } },
    },
    init = function()
      -- It's gonna be in the lualine
      vim.o.showmode = false
    end,
  },

  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
    event = "VeryLazy",
    opts = {},
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    -- We require telescope() directly
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "fdschmidt93/telescope-egrepify.nvim",
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-ts-autotag",
    },
    build = ":TSUpdate",
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  require("kickstart.plugins.autoformat"),
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  { import = "custom.plugins" },
  { import = "custom.plugins.languages" },
})

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

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require("nvim-treesitter.configs").setup({
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      "bash",
      "dockerfile",
      "fish",
      "go",
      "git_config",
      "gitcommit",
      "diff",
      "git_rebase",
      "gitignore",
      "gitattributes",
      "lua",
      "python",
      "sql",
      "javascript",
      "jsdoc",
      "json",
      "typescript",
      "tsx",
      "toml",
      "yaml",
      "vimdoc",
      "vim",
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    autotag = {
      enable = true,
    },
    -- filed an issue on how diff was being weird with + and -
    highlight = { enable = true },
    indent = {
      enable = true,
      -- it never works well with SQL unfortunately
      disable = { "sql" },
    },
    incremental_selection = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
        node_decremental = "<M-space>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]f"] = "@function.outer",
          ["]C"] = "@class.outer",
        },
        goto_next_end = {
          ["]F"] = "@function.outer",
          ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          ["[f"] = "@function.outer",
          ["[c"] = "@class.outer",
        },
        goto_previous_end = {
          ["[F"] = "@function.outer",
          ["[C"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>A"] = "@parameter.inner",
        },
      },
    },
  })
end, 0)

-- Setup neovim lua configuration
require("neodev").setup()

require("custom.lsp")
require("custom.settings")
require("custom.mappings")
require("custom.telescope")
