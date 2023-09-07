return {
  {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({})
    local opts = { noremap = true, silent = false }
    vim.keymap.set("n", "<Leader>tf", ":NvimTreeFindFileToggle<CR>", opts) --  'toggle file explorer'
    vim.keymap.set("n", "<Leader>of", ":NvimTreeFindFile!<CR>", opts)   --  'open file explorer'
  end,
  }
}
