return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    local snacks = require("snacks")
    snacks.setup({
      bigfile = { enabled = true },
      scroll = { enabled = true },
      gitbrowse = {
        url_patterns = {
          ["github%.com"] = {
            branch = "/tree/{branch}",
            file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
            commit = "/commit/{commit}",
          },
          -- any url with `gitlab.` should use these rules. Useful for working
          -- with private gitlab instances.
          [".*gitlab%..+"] = {
            branch = "/-/tree/{branch}",
            file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
            commit = "/-/commit/{commit}",
          },
          ["bitbucket%.org"] = {
            branch = "/src/{branch}",
            file = "/src/{branch}/{file}#lines-{line_start}-L{line_end}",
            commit = "/commits/{commit}",
          },
        },
      },
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

    -- TODO: Make the user command respect visual selection as well
    vim.api.nvim_create_user_command("GBrowse", "lua require('snacks').gitbrowse.open()", {})
    vim.keymap.set({ "n", "x" }, "<leader>gb", snacks.gitbrowse.open, { desc = "[G]it [B]rowse" })
  end,
}
