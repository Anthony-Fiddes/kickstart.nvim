-- windo but it goes back to the original window
local function windo(command)
  return function()
    local current_win = vim.fn.win_getid()
    vim.cmd("windo " .. command)
    vim.api.nvim_set_current_win(current_win)
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
vim.keymap.set("n", "ya\"", "2yi\"", { desc = "Yank quote with \", without whitespace" })
vim.keymap.set("n", "ya'", "2yi'", { desc = "Yank quote with ', without whitespace" })
vim.keymap.set("n", "ya`", "2yi`", { desc = "Yank quote with `, without whitespace" })

-- Misc
vim.keymap.set("n", "<leader>cd", "<Cmd>cd %:p:h<CR>:pwd<CR>", { desc = "[C]hange [D]irectory to that of current file" })
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "[N]o [H]ighlight" })
vim.keymap.set("n", "c", '"_c')
