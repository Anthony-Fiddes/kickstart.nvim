return {
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
      pyenv_path = vim.fn.expand("~/.pyenv/versions"),
    },
    cmd = {
      "VenvSelect",
    },
    keys = {
      -- Keymap to open VenvSelector to pick a venv.
      { "<leader>vs", "<cmd>VenvSelect<cr>" },
    },
    ft = "python",
  },
}
