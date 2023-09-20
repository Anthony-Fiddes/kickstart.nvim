return {
  "zbirenbaum/copilot-cmp",
  dependencies = { 'zbirenbaum/copilot.lua' },
  event = "InsertEnter",
  cmd = "Copilot",
  config = function()
    require("copilot").setup({})
    require("copilot_cmp").setup(
      {
        suggestion = { enabled = false },
        panel = { enabled = false },
      }
    )
  end,
  enabled = vim.g.copilot_enabled == true
}
