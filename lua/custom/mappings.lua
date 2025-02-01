-- windo, but it goes back to the original window
---@param command string
---@param silent boolean?
---@return function
local function windo(command, silent)
  return function()
    -- This makes it so that the cursor doesn't jump down to the cmdline and
    -- back
    if silent then
      command = "silent " .. command
    end
    -- Don't do anything if there's only one window.
    --
    -- This is pretty much exclusively so that zen-mode doesn't exit everytime I
    -- want to save the buffer.
    local windows = vim.api.nvim_tabpage_list_wins(0)
    if #windows == 1 then
      vim.cmd(command)
      return
    end

    local original_win = vim.fn.win_getid()
    vim.cmd("windo " .. command)
    if vim.api.nvim_win_is_valid(original_win) then
      vim.api.nvim_set_current_win(original_win)
    end
  end
end

-- Open window management
vim.keymap.set("n", "<leader>u", windo("update", true), { desc = "[U]pdate files (:update)" })
vim.keymap.set("n", "<leader>rf", windo("e!", true), { desc = "[R]eload [F]iles (:e!)" })
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

-- Indentation
vim.keymap.set("n", "<C-i>", "<C-i>", { noremap = true })
vim.keymap.set("n", "<Tab>", ">>", { desc = "󰉶 indent" })
vim.keymap.set("x", "<Tab>", ">gv", { desc = "󰉶 indent" })
vim.keymap.set("i", "<Tab>", "<C-t>", { desc = "󰉶 indent" })
vim.keymap.set("n", "<S-Tab>", "<<", { desc = "󰉵 outdent" })
vim.keymap.set("x", "<S-Tab>", "<gv", { desc = "󰉵 outdent" })
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "󰉵 outdent" })

-- Toggles
vim.keymap.set("n", "<leader>th", ":set hlsearch!<CR>", { desc = "[T]oggle Search [H]ighlight" })
vim.keymap.set("n", "<leader>tl", ":set list!<CR>", { desc = "[T]oggle [L]ist (show/hide white space)" })
vim.keymap.set("n", "<leader>ts", ":set spell!<CR>", { desc = "[T]oggle [S]pellcheck" })
vim.keymap.set("n", "<leader>tq", function()
  -- somehow it seems like there would be a more straightforward way to do this?
  local qf_info = vim.fn.getqflist({ winid = 0, size = 0 })
  local qf_win_id = qf_info.winid
  local qf_size = qf_info.size
  if qf_size == 0 then
    print("quickfix list is empty")
    return
  end
  if qf_win_id == 0 then
    vim.cmd("cwindow")
  else
    vim.cmd("cclose")
  end
end, { desc = "[T]oggle [Q]uickfix Window" })

-- Movement
vim.keymap.set("n", "<C-d>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { noremap = true })
-- I may press page up and down but the c-u/c-d behavior is what I want
vim.keymap.set("n", "<PageDown>", "<C-d>zz", { noremap = true })
vim.keymap.set("n", "<PageUp>", "<C-u>zz", { noremap = true })

-- Misc
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "[N]o [H]ighlight" })
vim.keymap.set("n", "<esc>", ":nohlsearch<CR>", { desc = "No Highlight", silent = true })
vim.keymap.set({ "n", "v" }, "c", '"_c')
-- this is pretty much always what I mean to do when I press . with a visual
-- selection
vim.keymap.set("x", ".", ":norm .<CR>")
vim.keymap.set("n", "<leader>L", ":Lazy<CR>")

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

-- Aesthetics
vim.keymap.set("n", "<leader>tb", function()
  local current = vim.o.background
  if current == "dark" then
    vim.o.background = "light"
  else
    vim.o.background = "dark"
  end
end, { desc = "[T]oggle [B]ackground" })
