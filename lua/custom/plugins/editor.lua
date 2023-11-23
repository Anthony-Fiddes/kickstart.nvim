return {
  {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x", -- version is optional, but recommended
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "mtoohey31/cmp-fish",
    ft = "fish",
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
    lazy = false,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
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
    opts = { skipInsignificantPunctuation = false },
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
        should_autosave = nil, -- function to determine if a session should be autosaved
        autoload = true, -- automatically load the session for the cwd on Neovim startup
        on_autoload_no_session = nil, -- function to run when `autoload = true` but there is no session to load
        follow_cwd = false, -- change session file name to match current working directory if it changes
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
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
  },
}
