return {
  {
    'creativenull/efmls-configs-nvim',
    version = 'v1.x.x', -- version is optional, but recommended
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  {
    'mtoohey31/cmp-fish',
    ft = "fish"
  },
  {
    'echasnovski/mini.bufremove',
    version = false,
    config = function()
      require('mini.bufremove').setup()
    end,
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "[B]uffer [D]elete" },
      {
        "<leader>bD",
        function() require("mini.bufremove").delete(0, true) end,
        desc = "[B]uffer [D]elete (Force)"
      },
    },
  },
  {
    'echasnovski/mini.surround',
    version = false,
    lazy = false,
    config = function()
      require('mini.surround').setup({
        mappings = {
          add = 'S',      -- Add surrounding in Normal and Visual modes
          delete = 'ds',   -- Delete surrounding
          replace = 'cs',  -- Replace surrounding
          find = 'gsf',     -- Find surrounding (to the right)
          find_left = 'gsF', -- Find surrounding (to the left)
          highlight = 'gsh', -- Highlight surrounding
          update_n_lines = 'gsn', -- Update `n_lines`

          suffix_last = 'l', -- Suffix to search with "prev" method
          suffix_next = 'n', -- Suffix to search with "next" method
        },
      })
    end,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
