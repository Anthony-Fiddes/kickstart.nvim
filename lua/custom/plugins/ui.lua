return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>tf",
        ":NvimTreeFindFileToggle<CR>",
        desc = "[T]oggle [F]ile tree",
        noremap = true,
        silent = false,
      },
      {
        "<leader>of",
        ":NvimTreeFindFile!<CR>",
        desc = "[O]pen Current [F]ile",
        noremap = true,
        silent = false,
      },
    },
    config = true,
  },
  {
    "echasnovski/mini.indentscope",
    version = "*",
    opts = {
      draw = { delay = 10 },
    },
  },
}
