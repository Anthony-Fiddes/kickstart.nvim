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
    config = true,
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
    config = true,
    version = false,
    lazy = false,
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = { labels = "arstdhneioplvm" },
    keys = {
      {
        "S",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter() end,
        desc =
        "[S] Flash Treesitter"
      },
      {
        "r",
        mode = "o",
        function() require("flash").remote() end,
        desc =
        "[r] Remote Flash"
      },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc =
        "Treesitter Search"
      },
      {
        "<C-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc =
        "Toggle Flash Search"
      },
    },
  }
}
