return {
  {
    "echasnovski/mini.indentscope",
    version = "*",
    opts = {
      draw = { delay = 10 },
      symbol = "│",
      options = {
        try_as_border = true,
      },
    },
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
      notify.setup({ timeout = 2500 })
      vim.notify = notify
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- didn't work well on some computers with an event = "VeryLazy"
    -- also, there's a problem where using the builtin command to "toggle"
    -- context just makes it not work.
  },
}
