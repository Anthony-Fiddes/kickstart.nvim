return {
  -- Git related plugins
  {
    "tpope/vim-fugitive",
    config = function()
      local function cmd(command)
        return function()
          if type(command) == "table" then
            for _, c in pairs(command) do
              vim.cmd(c)
            end
          else
            vim.cmd(command)
          end
        end
      end

      -- Fugitive
      -- :update before running :G so that the changes are up to date
      vim.keymap.set("n", "<Leader>g", cmd({ "update", "G" }), { desc = "[G]it" })
      vim.api.nvim_create_autocmd("User", {
        pattern = "FugitiveIndex",
        callback = function(args)
          vim.keymap.set("n", "cc", cmd("G commit -v"), { buffer = args.buf, desc = "Git commit" })
          vim.keymap.set("n", "ca", cmd("G commit --amend -v"), { buffer = args.buf, desc = "Git amend" })
          vim.keymap.set("n", "p", cmd("G push"), { buffer = args.buf, noremap = true, desc = "Git push" })
          vim.keymap.set("n", "P", cmd("G pull"), { buffer = args.buf, noremap = true, desc = "Git pull" })
          vim.keymap.set("n", "<Leader>g", "gq", { buffer = args.buf, remap = true, desc = "Close Fugitive" })
        end,
      })
    end,
  },
  "tpope/vim-rhubarb",
  {
    "shumphrey/fugitive-gitlab.vim",
    config = function()
      vim.g.fugitive_gitlab_domains = require("custom.vars").gitlab_domains
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "arstdhneioplvm",
    },
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
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
      },
    },
    opts = { skipInsignificantPunctuation = false },
  },
  -- automatically converts a string to an f-string or template string when a
  -- variable is referenced in python/javascript/lua
  {
    "chrisgrieser/nvim-puppeteer",
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },
  {
    "olimorris/persisted.nvim",
    config = function()
      local should_autoload = function()
        -- if any of these args are present when calling nvim, don't autoload
        -- the directory's session.
        local skip_autoload_args = {
          "-",
          "+Man!",
          "lua require('kitty-vi-mode')",
        }
        local autoload = vim.iter(skip_autoload_args):all(function(arg)
          return not vim.tbl_contains(vim.v.argv, arg)
        end)
        return autoload
      end

      local persisted = require("persisted")
      persisted.setup({
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- directory where session files are saved
        silent = false, -- silent nvim message when sourcing session file
        use_git_branch = false, -- create session files based on the branch of the git enabled repository
        autosave = true, -- automatically save session files when exiting Neovim
        autoload = should_autoload(),
        follow_cwd = false, -- don't change session file name to match current working directory if it changes
        allowed_dirs = nil, -- table of dirs that the plugin will auto-save and auto-load from
        ignored_dirs = nil, -- table of dirs that are ignored when auto-saving and auto-loading
        telescope = { -- options for the telescope extension
          reset_prompt_after_deletion = true, -- whether to reset prompt after session deleted
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "PersistedSavePre",
        callback = function()
          local banned_filetypes = {
            gitcommit = true,
            checkhealth = true,
          }
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local filetype = vim.bo[buf].filetype
            if banned_filetypes[filetype] then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end,
      })

      -- Load telescope plugin if it's available
      local ok, telescope = pcall(require, "telescope")
      if ok then
        telescope.load_extension("persisted")
        vim.keymap.set("n", "<leader>P", require("telescope").extensions.persisted.persisted, { desc = "Find [P]roject" })
      end
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    opts = {
      default_mappings = false,
    },
    config = function()
      -- Setting mappings manually because if you don't type them fast enough,
      -- vim thinks that you're providing a text object / motion to c.
      --
      -- Something to consider if it ever bothers me: I could use the provided
      -- autocmds to load these mappings only whene there's actually a conflict
      -- present in a buffer.
      vim.keymap.set("n", "<Leader>co", "<Plug>(git-conflict-ours)", { desc = "[C]hoose [O]urs (resolve git conflict)" })
      vim.keymap.set("n", "<Leader>ct", "<Plug>(git-conflict-theirs)", { desc = "[C]hoose [T]heirs (resolve git conflict)" })
      vim.keymap.set("n", "<Leader>cb", "<Plug>(git-conflict-both)", { desc = "[C]hoose [B]oth (resolve git conflict)" })
      vim.keymap.set("n", "<Leader>c0", "<Plug>(git-conflict-none)", { desc = "[C]hoose [N]one (resolve git conflict)" })
      -- These are already implemented by mini.bracketed
      -- vim.keymap.set("n", "[x", "<Plug>(git-conflict-prev-conflict)")
      -- vim.keymap.set("n", "]x", "<Plug>(git-conflict-next-conflict)")
    end,
  },
}
