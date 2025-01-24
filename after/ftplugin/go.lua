local gopher_exists = pcall(require, "gopher")
if not gopher_exists then
  vim.notify("gopher.nvim was not found. If it was removed, please remove the corresponding keymaps in after/ftplugin/go.lua", vim.log.levels.WARN)
else
  vim.keymap.set("n", "<Leader>ie", ":GoIfErr<CR>", { buffer = true, desc = "[i]ff [e]rr" })
  vim.keymap.set("n", "<Leader>im", ":GoImpl ", { buffer = true, desc = "Generate [IM]plementation" })
end
