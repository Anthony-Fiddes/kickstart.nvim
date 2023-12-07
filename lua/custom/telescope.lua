-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`

local actions = require("telescope.actions")
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
  pickers = {
    buffers = {
      mappings = {
        i = {
          ["d"] = actions.delete_buffer,
        },
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
local telescope = require("telescope.builtin")

-- Following functions heavily inspired by or taken from
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes

-- We cache the results of "git rev-parse"
-- because process creation is expensive in Windows, so this reduces latency
local _is_inside_work_tree = {}

-- Returns nil if not in a git project
local function get_git_root()
  -- I can just use the current directory since mini.misc handles auto changing
  -- it upon entering a new buffer.
  local cwd = vim.fn.getcwd()
  if _is_inside_work_tree[cwd] == nil then
    vim.fn.system("git rev-parse --is-inside-work-tree")
    _is_inside_work_tree[cwd] = vim.v.shell_error == 0
  end
  if not _is_inside_work_tree[cwd] then
    return nil
  end

  local dot_git_path = vim.fn.finddir(".git", ".;")
  local submodule = vim.fn.findfile(".git", ".;" .. dot_git_path)
  if submodule and submodule ~= "" then
    local submodule_root = vim.fn.fnamemodify(submodule, ":h")
    return submodule_root
  else
    local git_root = vim.fn.fnamemodify(dot_git_path, ":h")
    return git_root
  end
end

local function project_files()
  local opts = {
    use_git_root = true,
    show_untracked = true,
  }

  local git_root = get_git_root()
  if not git_root then
    telescope.find_files(opts)
  else
    telescope.git_files(opts)
  end
end

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>hh", telescope.oldfiles, { desc = "[hh] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", telescope.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  telescope.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer", noremap = true })
vim.keymap.set("n", "<C-f>", "<leader>/", { remap = true })
vim.keymap.set("n", "<leader>gs", telescope.git_status, { desc = "Show files changed in [G]it [S]tatus" })
vim.keymap.set("n", "<leader>gc", telescope.git_commits, { desc = "Show [G]it [C]ommits" })
vim.keymap.set("n", "<leader>p", project_files, { desc = "Find [P]roject Files" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", telescope.grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>ff", telescope.live_grep, { desc = "[F]ind in [f]iles (live_grep)" })
vim.keymap.set("n", "<leader>fd", telescope.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", telescope.resume, { desc = "[F]ind [R]resume" })
vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "[F]ind [k]eymaps" })
vim.keymap.set("n", "<leader>f/", telescope.search_history, { desc = "[F]ind in search [/] history" })
vim.keymap.set("n", "<leader>f:", telescope.command_history, { desc = "[F]ind in command [:] history" })
vim.keymap.set("n", '<leader>f"', telescope.registers, { desc = '[F]ind in registers ["]' })
vim.keymap.set("n", "<leader>fc", telescope.commands, { desc = "[F]ind [C]ommands" })
