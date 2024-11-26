return {
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
      notify.setup({ timeout = 2500 })
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
