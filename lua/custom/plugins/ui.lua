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
}
