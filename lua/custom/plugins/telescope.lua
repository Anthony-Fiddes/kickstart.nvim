-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`

-- Fuzzy Finder (files, lsp, etc)
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "debugloop/telescope-undo.nvim",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-s>"] = actions.select_horizontal,
          },
          n = {
            ["<C-s>"] = actions.select_horizontal,
            ["ZZ"] = actions.close,
          },
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "undo")

    vim.keymap.set("n", "<leader>fu", "<cmd>Telescope undo<CR>", { desc = "[F]ind [U]ndo" })
  end,
}
