return {
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    event = "InsertEnter",
    cmd = "Copilot",
    config = function()
      require("copilot").setup({})
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
    enabled = vim.g.copilot_enabled == true,
  },
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup({})
    end,
    enabled = vim.g.codeium_enabled == true,
  },
}
