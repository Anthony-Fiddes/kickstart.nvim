-- windo but it goes back to the original window
local function windo(command)
  return function()
    local original_win = vim.fn.win_getid()
    local windows = vim.api.nvim_list_wins()
    for _, window in pairs(windows) do
      vim.api.nvim_set_current_win(window)
      if vim.fn.bufname() == "" then
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
vim.keymap.set("n", "ZA", ":wqa<CR>", { desc = "Save and close all" })
vim.keymap.set("n", "<C-t>", ":tabnew<CR>", { desc = "Open a new tab" })

local function toggle_diagnostics()
  if vim.w.diag_disabled then
    vim.diagnostic.enable()
    vim.w.diag_disabled = false
  else
    vim.diagnostic.enable(false)
    vim.w.diag_disabled = true
  end
end

-- LSP
vim.keymap.set("n", "<leader>td", toggle_diagnostics, { desc = "[T]oggle [D]iagnostics" })

-- Toggles
vim.keymap.set("n", "<leader>th", ":set hlsearch!<CR>", { desc = "[T]oggle Search [H]ighlight" })
vim.keymap.set("n", "<leader>tl", ":set list!<CR>", { desc = "[T]oggle [L]ist (show/hide white space)" })
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", { desc = "[T]oggle [S]pellcheck" })

-- Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
vim.keymap.set("n", "<PageUp>", "<PageUp>zz", { noremap = true })
vim.keymap.set("n", "<PageDown>", "<PageDown>zz", { noremap = true })

-- Misc
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "[N]o [H]ighlight" })
vim.keymap.set("n", "<esc>", ":nohlsearch<CR>", { desc = "No Highlight", silent = true })
vim.keymap.set({ "n", "v" }, "c", '"_c')

-- document key chains
require("which-key").add({
  { "<leader>c", group = "[C]ode" },
  { "<leader>f", group = "[F]ind" },
  { "<leader>h", group = "Git [H]unk" },
  { "<leader>r", name = "[R]ename" },
  { "<leader>s", name = "[S]urrounding" },
  { "<leader>t", name = "[T]oggle" },
  { "<leader>w", name = "[W]orkspace" },
})

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating [D]iagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Kickstart keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
