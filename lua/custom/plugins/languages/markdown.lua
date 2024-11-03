return {
  {
    "ixru/nvim-markdown",
    ft = "markdown",
    config = function()
      -- don't conflict with treesitter conceal
      vim.g.vim_markdown_folding_disabled = 1
    end,
  },
  {
    "ellisonleao/glow.nvim",
    keys = {
      { "<leader>md", ":Glow<CR>", desc = "[md] Glow Preview" },
    },
    config = true,
    ft = "markdown",
  },
}
