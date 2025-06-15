return {
  -- Git related plugins
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "ibhagwan/fzf-lua",
    },
    config = function()
      local diffview_mappings = {
        { "n", "ZZ", ":DiffviewClose<CR>", { desc = "Close Diffview" } },
      }
      require("diffview").setup({
        keymaps = {
          view = diffview_mappings,
          file_view = diffview_mappings,
          file_history_panel = diffview_mappings,
          file_panel = diffview_mappings,
          diff1 = diffview_mappings,
          diff2 = diffview_mappings,
          diff3 = diffview_mappings,
          diff4 = diffview_mappings,
        },
      })
      vim.keymap.set("n", "<Leader>gh", ":DiffviewFileHistory %<CR>", { desc = "View [G]it [H]istory for current file" })
      vim.keymap.set("n", "<Leader>gd", ":DiffviewOpen<CR>", { desc = "Open [G]it [D]iff view for current changes" })

      local git_augroup = vim.api.nvim_create_augroup("git-plugins", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = git_augroup,
        pattern = "PersistedSavePre",
        callback = function()
          -- snippet taken from:
          -- https://github.com/sindrets/diffview.nvim/issues/409#issuecomment-1664510013
          for _, view in ipairs(require("diffview.lib").views) do
            view:close()
          end
        end,
      })

      local graph_style = "ascii"
      if os.getenv("KITTY_PID") ~= nil then
        graph_style = "kitty"
      end
      local neogit = require("neogit")
      neogit.setup({
        integrations = {
          telescope = false,
        },
        graph_style = graph_style,
        mappings = {
          popup = {
            ["Z"] = false,
            ["z"] = "StashPopup",
          },
          commit_editor = {
            ["<c-c><c-c>"] = false,
            ["<c-c><c-k>"] = false,
            ["ZZ"] = "Submit",
            ["ZQ"] = "Abort",
          },
          status = {
            ["<Leader>rf"] = "RefreshBuffer",
          },
        },
      })

      local toggle_neogit = function()
        if vim.bo.filetype:find("Neogit") then
          return ":q<CR>"
        end
        -- don't show out of date changes...
        return ":wa<CR>:Neogit<CR>"
      end
      vim.keymap.set("n", "<Leader>tg", toggle_neogit, { silent = true, desc = "[T]oggle Neo[g]it", expr = true })
      vim.keymap.set("n", "<Leader>gg", toggle_neogit, { silent = true, desc = "Toggle Neo[g]it", expr = true })
      vim.keymap.set("n", "<Leader>gcc", neogit.action("commit", "commit", nil), { desc = "Neo[g]it [C]ommit" })

      vim.api.nvim_create_autocmd("User", {
        group = git_augroup,
        pattern = "NeogitStatusRefreshed",
        callback = function()
          vim.cmd("checktime")
        end,
      })
    end,
  },

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
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, expr = expr, noremap = true })
        end

        local gs = require("gitsigns")
        map("n", "<Leader>hb", function()
          gs.blame_line({ full = true })
        end, "[hb] Show git blame for hunk")
        map("n", "hp", gs.preview_hunk, "[H]unk [P]review")
        map("n", "<Leader>hs", gs.stage_hunk, "[hs] Stage/Unstage Hunk")
        map("n", "<Leader>hS", gs.stage_buffer, "[hS] Stage Buffer")
        map("n", "<Leader>hU", gs.reset_buffer_index, "[hU] Unstage buffer")
        map("n", "<Leader>hr", gs.reset_hunk, "[hr] Reset Hunk")
        map("n", "<Leader>hR", gs.reset_buffer, "[hR] Reset Buffer")
        -- hunk text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")

        map("v", "<leader>hs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "[hs] Stage Hunk")
        map("v", "<leader>hr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "[hr] Reset Hunk")

        local function next_hunk()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.nav_hunk("next")
          end)
          return "<Ignore>"
        end
        map({ "n", "v" }, "<Leader>hn", next_hunk, "[hn] Jump to next hunk", true)
        map({ "n", "v" }, "]h", next_hunk, "Jump to next hunk", true)

        local function prev_hunk()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.nav_hunk("prev")
          end)
          return "<Ignore>"
        end
        map({ "n", "v" }, "<Leader>hN", prev_hunk, "[hN] Jump to previous hunk", true)
        map({ "n", "v" }, "[h", prev_hunk, "Jump to previous hunk", true)
      end,
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "arstdhneioplvm",
    },
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump()
        end,
        desc = "[s] Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "[S] Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "[r] Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<C-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
      },
    },
    opts = { skipInsignificantPunctuation = false },
  },
  -- automatically converts a string to an f-string or template string when a
  -- variable is referenced in python/javascript/lua
  {
    "chrisgrieser/nvim-puppeteer",
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },
  {
    "olimorris/persisted.nvim",
    config = function()
      local should_autoload = function()
        -- if any of these args are present when calling nvim, don't autoload
        -- the directory's session.
        local skip_autoload_args = {
          "-",
          "+Man!",
          "lua require('kitty-vi-mode')",
        }
        local autoload = vim.iter(skip_autoload_args):all(function(arg)
          return not vim.tbl_contains(vim.v.argv, arg)
        end)
        return autoload
      end

      local persisted = require("persisted")
      persisted.setup({
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
        silent = false, -- silent nvim message when sourcing session file
        use_git_branch = false, -- create session files based on the branch of the git enabled repository
        autosave = true, -- automatically save session files when exiting Neovim
        autoload = should_autoload(),
        follow_cwd = false, -- don't change session file name to match current working directory if it changes
        allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
        ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
        telescope = { -- options for the telescope extension
          reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistedSavePre",
        callback = function()
          local banned_filetypes = {
            gitcommit = true,
            checkhealth = true,
            qf = true,
          }
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local filetype = vim.bo[buf].filetype
            if banned_filetypes[filetype] or filetype:find("Neogit") then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      })

      -- Load telescope plugin if it's available
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension("persisted")
        vim.keymap.set("n", "<leader>P", require("telescope").extensions.persisted.persisted, { desc = "Find [P]roject" })
      end
    end,
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    -- foldexpr doesn't work on files opened from a previous session if this is lazy loaded, so it's just not worth it...
    lazy = false,
    main = "nvim-treesitter.configs",
    opts = {
      -- Add languages to be installed here that you want installed for treesitter
      ensure_installed = {
        "bash",
        "dockerfile",
        "fish",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "git_config",
        "gitcommit",
        "diff",
        "git_rebase",
        "gitignore",
        "gitattributes",
        "helm",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "sql",
        "javascript",
        "jsdoc",
        "json",
        "typescript",
        "tsx",
        "terraform",
        "hcl",
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
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        -- It never works well with SQL unfortunately.
        -- With YAML it puts the cursor in very odd places when pressing one of
        -- the `indentkeys`. I noticed it most with `:`
        disable = { "sql", "yaml" },
      },
      incremental_selection = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          init_selection = "<c-space>",
          scope_incremental = "<c-s>",
          node_incremental = "v",
          node_decremental = "V",
        },
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
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
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    build = ":TSUpdate",
  },

  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

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
  {

    "stevearc/quicker.nvim",
    event = "VeryLazy",
    config = function()
      local quicker = require("quicker")
      quicker.setup({
        edit = {
          autosave = true,
        },
        keys = {
          {
            ">",
            function()
              require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
            end,
            desc = "Expand quickfix context",
          },
          {
            "<",
            function()
              require("quicker").collapse()
            end,
            desc = "Collapse quickfix context",
          },
        },
        on_qf = function(buf)
          -- this is probably okay since there's only one quickfix list
          local prev_inccommand = nil
          local set_nosplit = function()
            prev_inccommand = vim.o.inccommand
            vim.o.inccommand = "nosplit"
          end
          local inccommand_augroup = vim.api.nvim_create_augroup("set-inccommand-in-qf-list", { clear = true })
          vim.api.nvim_create_autocmd("BufEnter", {
            buffer = buf,
            group = inccommand_augroup,
            callback = set_nosplit,
          })
          -- on_qf is just a filetype autocmd for the qf filetype. That event
          -- isn't triggered the first time the quickfix list is opened, so we
          -- have to run the callback here to get started (this event triggering
          -- means that the quickfix list buffer was opened).
          set_nosplit()

          vim.api.nvim_create_autocmd("BufLeave", {
            buffer = buf,
            group = inccommand_augroup,
            callback = function()
              vim.o.inccommand = prev_inccommand
            end,
          })
        end,
      })
    end,
  },
}
