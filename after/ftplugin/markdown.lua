-- Wrap text as I type
vim.opt_local.formatoptions:append("t")
vim.opt_local.spell = true
vim.opt_local.expandtab = true

-- below code is slightly modified from
-- https://github.com/chrisgrieser/.config/blob/main/nvim/after/ftplugin/markdown.lua

-- make bullets auto-continue (simple replacement for bullets.vim)
-- INFO: cannot set opt.comments permanently, since it disturbs the
-- correctly indented continuation of bullet lists when hitting opt.textwidth
vim.opt_local.formatoptions:append("r") -- `<CR>` in insert mode
vim.opt_local.formatoptions:append("o") -- `o` in normal mode

local function autocontinue(key)
  return function()
    local original_comments = vim.opt_local.comments:get()
    vim.opt_local.comments = {
      "b:- [ ]",
      "b:- [x]",
      "b:\t* [ ]",
      "b:\t* [x]", -- tasks
      "b:*",
      "b:-",
      "b:+",
      "b:\t*",
      "b:\t-",
      "b:\t+", -- unordered list
      "b:1.",
      "b:\t1.", -- ordered list
      "n:>", -- blockquotes
    }
    local valid_key = vim.api.nvim_replace_termcodes(key, true, false, true)
    -- nvim_feedkeys is blocking
    vim.api.nvim_feedkeys(valid_key, "n", false)
    -- This is black magic to me. Since I don't understand how vim works very
    -- well, it seems like it shouldn't be needed if nvim_feedkeys is blocking
    -- (which was the only reason I tried feedkeys here originally!)
    vim.defer_fn(function()
      vim.opt_local.comments = original_comments
    end, 1)
  end
end

vim.keymap.set("n", "o", autocontinue("o"), { expr = true, buffer = true })
vim.keymap.set("n", "O", autocontinue("O"), { expr = true, buffer = true })
vim.keymap.set("i", "<CR>", autocontinue("<CR>"), { expr = true, buffer = true })

-- ctrl+k: markdown link
vim.keymap.set("x", "<C-k>", "<Esc>`<i[<Esc>`>la]()<Esc>i", { desc = " Link", buffer = true, noremap = true })
vim.keymap.set("i", "<C-k>", "[]()<Left><Left><Left>", { desc = " Link", buffer = true, noremap = true })
