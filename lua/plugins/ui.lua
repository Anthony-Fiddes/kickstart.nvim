return {

  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        background = { -- :h background
          light = "latte",
          dark = "macchiato",
        },
        integrations = {
          notify = true,
          -- this integration disables highlighting so it's much harder for me
          -- to see
          flash = false,
          diffview = true,
        },
      })
      vim.cmd("colorscheme catppuccin")
    end,
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy",
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim", opts = {} },

  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = "catppuccin",
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

  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    init = function()
      vim.keymap.set("n", "<leader>tz", ":ZenMode<CR>", { desc = "[T]oggle [Z]enMode" })
    end,
    opts = {
      plugins = {
        kitty = {
          enabled = os.getenv("KITTY_PID") ~= nil,
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup({
        timeout = 2500,
        on_open = function(win)
          -- never let <c-w> focus a notify window!
          -- taken from: https://github.com/rcarriga/nvim-notify/issues/183#issuecomment-1464892813
          vim.api.nvim_win_set_config(win, { focusable = false })
        end,
      })
      vim.notify = notify
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- didn't work well on some computers with an event = "VeryLazy"
    config = function()
      vim.keymap.set("n", "<leader>tc", ":TSContextToggle<CR>", { desc = "[T]oggle TS [C]ontext" })
    end,
  },
}
