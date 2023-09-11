-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
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
    'echasnovski/mini.nvim',
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
    'folke/todo-comments.nvim',
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    'ixru/nvim-markdown',
    ft = "markdown"
  }
}
