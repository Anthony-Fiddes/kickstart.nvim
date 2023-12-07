local function map(lhs, rhs)
  vim.keymap.set({ "n", "v" }, lhs, rhs, { buffer = true, noremap = true })
end

local function cmd(command)
  return function()
    vim.cmd(command)
  end
end

-- Not working yet
-- map("cc", cmd("Git commit -v"))
-- map("ca", cmd("Git commit --amend -v"))
