return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require("snacks")
    snacks.setup({
      bigfile = { enabled = true },
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesActionRename",
      callback = function(event)
        snacks.rename.on_rename_file(event.data.from, event.data.to)
        -- if files are updated, I don't want to have to :wa manually
        vim.cmd("wa")
      end,
    })

    vim.keymap.set("n", "<leader>tt", function()
      Snacks.terminal()
    end, { desc = "[T]oggle [T]erminal" })
  end,
}
