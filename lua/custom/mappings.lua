-- windo but it goes back to the original window
local function windo(command)
  return function()
    local original_win = vim.fn.win_getid()
    local windows = vim.api.nvim_list_wins()
    for _, window in pairs(windows) do
      vim.api.nvim_set_current_win(window)
      if vim.bo.filetype == "" then
        -- Ignore scratch buffers
        goto continue
      end
      vim.cmd(command)
      ::continue::
    end
    vim.api.nvim_set_current_win(original_win)
  end
end

-- Open window management
vim.keymap.set("n", "<leader>u", windo("update"), { desc = "[U]pdate files (:update)" })
vim.keymap.set("n", "<leader>rf", windo("e!"), { desc = "[R]eload [F]iles (:e!)" })
vim.keymap.set("n", "<leader>on", ":on<CR>", { desc = ":[on]ly (close all other windows)" })

local function toggle_diagnostics()
  if vim.w.diag_disabled then
    vim.diagnostic.enable()
    vim.w.diag_disabled = false
  else
    vim.diagnostic.disable()
    vim.w.diag_disabled = true
  end
end

-- LSP
vim.keymap.set("n", "<leader>td", toggle_diagnostics, { desc = "[T]oggle [D]iagnostics" })

-- Toggles
vim.keymap.set("n", "<leader>th", ":set hlsearch!<CR>", { desc = "[T]oggle Search [H]ighlight" })
vim.keymap.set("n", "<leader>tl", ":set list!<CR>", { desc = "[T]oggle [L]ist (show/hide white space)" })
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", { desc = "[T]oggle [S]pellcheck" })

-- Yank quotes without whitespace
vim.keymap.set("o", 'a"', '2i"', { desc = 'Yank in " quote without whitespace' })
vim.keymap.set("o", "a'", "2i'", { desc = "Yank in ' quote without whitespace" })
vim.keymap.set("o", "a`", "2i`", { desc = "Yank in ` quote without whitespace" })

-- Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })

-- Misc
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "[N]o [H]ighlight" })
vim.keymap.set("n", "c", '"_c')
