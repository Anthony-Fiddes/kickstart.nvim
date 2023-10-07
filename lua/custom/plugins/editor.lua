return {
  {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x", -- version is optional, but recommended
    dependencies = { "neovim/nvim-lspconfig" },
  },
  {
    "mtoohey31/cmp-fish",
    ft = "fish",
  },
  {
    "echasnovski/mini.bufremove",
    version = false,
    config = true,
    keys = {
      {
        "<leader>bd",
        function()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "[B]uffer [D]elete",
      },
      {
        "<leader>bD",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "[B]uffer [D]elete (Force)",
      },
    },
  },
  {
    "echasnovski/mini.surround",
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "<Leader>sa", -- Add surrounding in Normal and Visual modes
          delete = "<Leader>sd", -- Delete surrounding
          replace = "<Leader>sc", -- Replace surrounding
          find = "<Leader>sf", -- Find surrounding (to the right)
          find_left = "<Leader>sF", -- Find surrounding (to the left)
          highlight = "<Leader>sh", -- Highlight surrounding
          update_n_lines = "<Leader>sn", -- Update `n_lines`

          suffix_last = "l", -- Suffix to search with "prev" method
          suffix_next = "n", -- Suffix to search with "next" method
        },
      })
    end,
    version = false,
    lazy = false,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = { labels = "arstdhneioplvm" },
    config = function()
      require("flash").toggle(false)
    end,
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump()
        end,
        desc = "[s] Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "[S] Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "[r] Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<C-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "chrisgrieser/nvim-spider",
    keys = { "w", "e", "b", "ge" },
    config = function()
      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
    end,
    opts = { skipInsignificantPunctuation = false },
    lazy = true,
  },
}
