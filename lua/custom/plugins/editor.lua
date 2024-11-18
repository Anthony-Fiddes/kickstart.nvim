return {
  -- Git related plugins
  {
    "tpope/vim-fugitive",
    config = function()
      local function cmd(command)
        return function()
          if type(command) == "table" then
            for _, c in pairs(command) do
              vim.cmd(c)
            end
          else
            vim.cmd(command)
          end
        end
      end

      -- Fugitive
      -- :update before running :G so that the changes are up to date
      vim.keymap.set("n", "<Leader>g", cmd({ "update", "G" }), { desc = "[G]it" })
      vim.api.nvim_create_autocmd("User", {
        pattern = "FugitiveIndex",
        callback = function(args)
          vim.keymap.set("n", "cc", cmd("G commit -v"), { buffer = args.buf, desc = "Git commit" })
          vim.keymap.set("n", "ca", cmd("G commit --amend -v"), { buffer = args.buf, desc = "Git amend" })
          vim.keymap.set("n", "p", cmd("G push"), { buffer = args.buf, noremap = true, desc = "Git push" })
          vim.keymap.set("n", "P", cmd("G pull"), { buffer = args.buf, noremap = true, desc = "Git pull" })
          vim.keymap.set("n", "<Leader>g", "gq", { buffer = args.buf, remap = true, desc = "Close Fugitive" })
        end,
      })
    end,
  },
  "tpope/vim-rhubarb",
  {
    "shumphrey/fugitive-gitlab.vim",
    config = function()
      vim.g.fugitive_gitlab_domains = require("custom.vars").gitlab_domains
    end,
  },
  {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x", -- version is optional, but recommended
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "echasnovski/mini.ai",
    version = "*",
    event = "VeryLazy",
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- object (code block)
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }), -- argument
          d = { "%f[%d]%d+" }, -- digits
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      })
    end,
  },
  {
    "echasnovski/mini.files",
    version = false,
    dependencies = {
      "echasnovski/mini.icons",
    },
    config = function()
      require("mini.files").setup({
        mappings = {
          close = "q",
          go_in = "",
          go_in_plus = "<CR>",
          go_out = "",
          go_out_plus = "<BS>",
          reset = "`",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "<Leader>u",
          trim_left = "<",
          trim_right = ">",
        },
      })

      vim.keymap.set("n", "<Leader>of", function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        if buf_name ~= "" then
          MiniFiles.open(buf_name)
        else
          MiniFiles.open()
        end
      end, { desc = "[O]pen [F]ile tree" })

      local function sync_and_close()
        MiniFiles.synchronize()
        MiniFiles.close()
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "ZZ", sync_and_close, { buffer = args.data.buf_id })
          vim.keymap.set("n", "<esc>", sync_and_close, { buffer = args.data.buf_id })
        end,
      })
    end,
  },
  {
    "echasnovski/mini.surround",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "<Leader>sa", -- Add surrounding in Normal and Visual modes
          delete = "<Leader>sd", -- Delete surrounding
          replace = "<Leader>sc", -- Replace surrounding
          find = "<Leader>sf", -- Find surrounding (to the right)
          find_left = "<Leader>sF", -- Find surrounding (to the left)
          highlight = "<Leader>sh", -- Highlight surrounding
          update_n_lines = "<Leader>sn", -- Update `n_lines`

          suffix_last = "l", -- Suffix to search with "prev" method
          suffix_next = "n", -- Suffix to search with "next" method
        },
      })
    end,
    version = false,
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
  {
    "chrisgrieser/nvim-puppeteer",
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },
  {
    "olimorris/persisted.nvim",
    config = function()
      local persisted = require("persisted")
      persisted.setup({
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
        silent = false, -- silent nvim message when sourcing session file
        use_git_branch = false, -- create session files based on the branch of the git enabled repository
        autosave = true, -- automatically save session files when exiting Neovim
        autoload = true, -- automatically load the session for the cwd on Neovim startup
        follow_cwd = true, -- change session file name to match current working directory if it changes
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
          }
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local filetype = vim.bo[buf].filetype
            if banned_filetypes[filetype] then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      })

      -- Load telescope plugin if it's available
      pcall(require("telescope").load_extension("persisted"))
      vim.keymap.set("n", "<leader>P", require("telescope").extensions.persisted.persisted, { desc = "Find [P]roject" })
    end,
  },
  {
    "echasnovski/mini.misc",
    version = "*",
    event = "VeryLazy",
    config = function()
      local mini_misc = require("mini.misc")
      local fallback = function(buf_path)
        -- Just cd to the parent folder if you can't find a root marker
        return vim.fn.fnamemodify(buf_path, ":h")
      end
      mini_misc.setup_auto_root({ ".git", "package.json", "Makefile" }, fallback)
    end,
  },
  {
    "cappyzawa/trim.nvim",
    event = "BufWritePre",
    opts = {},
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
}
