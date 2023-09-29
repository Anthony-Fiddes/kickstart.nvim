-- Misc
vim.keymap.set("n", "<leader>cd", "<Cmd>cd %:p:h<CR>:pwd<CR>", { desc = "[C]hange [D]irectory to that of current file" })
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "[N]o [H]ighlight" })
vim.keymap.set("n", "<leader>u", ":windo update<CR>", { desc = '[U]pdate file (:update)' })
vim.keymap.set("n", "<leader>rf", ":windo e!<CR>", { desc = '[R]eload [F]ile (:e!)' })
vim.keymap.set("n", "<leader>tl", ":set list!<CR>", { desc = '[T]oggle [L]ist (show/hide white space)' })
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", { desc = '[T]oggle [S]pellcheck' })
vim.keymap.set("n", "<leader>on", ":on<CR>", { desc = ':[on]ly (close all other windows)' })
