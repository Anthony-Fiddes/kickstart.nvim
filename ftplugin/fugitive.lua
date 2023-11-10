local function map(lhs, rhs)
  vim.keymap.set({ "n", "v" }, lhs, rhs, { buffer = true, noremap = true })
end

-- Not working yet
map("cc", vim.cmd("Git commit -v"))
map("ca", vim.cmd("Git commit --amend -v"))
