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
}
