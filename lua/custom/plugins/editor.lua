return {
  {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x", -- version is optional, but recommended
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "echasnovski/mini.bufremove",
    version = false,
    config = true,
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "[B]uffer [D]elete",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "[B]uffer [D]elete (Force)",
      },
    },
  },
  {
    "echasnovski/mini.files",
    version = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
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
          synchronize = "<Space>",
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
      modes = {
        char = {
          config = function(opts)
            -- autohide flash when in operator-pending mode
            opts.autohide = opts.autohide or vim.fn.mode(true):find("no")

            -- disable jump labels when not enabled, when using a count,
            -- or when recording/executing registers
            opts.jump_labels = opts.jump_labels and vim.v.count == 0 and vim.fn.reg_executing() == "" and vim.fn.reg_recording() == ""
          end,
        },
      },
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
    opts = { skipInsignificantPunctuation = true },
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
        use_git_branch = true, -- create session files based on the branch of the git enabled repository
        autosave = true, -- automatically save session files when exiting Neovim
        autoload = true, -- automatically load the session for the cwd on Neovim startup
        follow_cwd = true, -- change session file name to match current working directory if it changes
        allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
        ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
        telescope = { -- options for the telescope extension
          reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
        },
      })

      local hooks = vim.api.nvim_create_augroup("PersistedHooks", {})
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "PersistedSavePre",
        group = hooks,
        callback = function()
          -- Ensure an NvimTree buffer can't mess up your session file
          pcall(vim.cmd, "NvimTreeClose")
        end,
      })
      -- Load telescope plugin if it's available
      pcall(require("telescope").load_extension("persisted"))
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
}
