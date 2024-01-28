local function go_to_tag_under_cursor()
  local tag_current_word = function()
    local current_word = vim.fn.expand("<cword>")
    vim.cmd("tag " .. current_word)
  end

  -- if the current word isn't a tag, just act like a regular enter
  if not pcall(tag_current_word) then
    vim.fn.feedkeys("\r", "n")
  end
end
vim.keymap.set("n", "<cr>", go_to_tag_under_cursor, { desc = "Go to tag under cursor", buffer = true })
