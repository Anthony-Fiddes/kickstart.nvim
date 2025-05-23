return {
  -- "gc" to comment visual regions/lines
  {
    "echasnovski/mini.nvim",
    version = false,
    lazy = false,
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      local ts_context_commentstring = require("ts_context_commentstring")
      ts_context_commentstring.setup({ enable_autocmd = false })
      local calculate_commentstring = function()
        -- fix commentstring for helm files similar to
        -- https://github.com/numToStr/Comment.nvim/issues/172
        if vim.bo.filetype == "helm" then
          return vim.bo.commentstring
        end
        return ts_context_commentstring.calculate_commentstring() or vim.bo.commentstring
      end

      require("mini.comment").setup({
        options = { custom_commentstring = calculate_commentstring },
      })

      require("mini.indentscope").setup({
        draw = { delay = 10 },
        symbol = "│",
        options = {
          try_as_border = true,
        },
      })

      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- object (code block)
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          d = { "%f[%d]%d+" }, -- digits
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
          g = function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      })

      require("mini.files").setup({
        mappings = {
          close = "q",
          go_in = "",
          go_in_plus = "<CR>",
          go_out = "",
          go_out_plus = "<BS>",
          reset = "`",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "<C-s>",
          trim_left = "<",
          trim_right = ">",
        },
        options = {
          use_as_default_explorer = true,
          permanent_delete = false,
        },
      })

      vim.keymap.set("n", "<Leader>of", function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        if vim.fn.filereadable(buf_name) == 1 then
          MiniFiles.open(buf_name)
          return
        end

        local buf_dir = vim.fs.dirname(buf_name)
        if vim.fn.isdirectory(buf_dir) == 1 then
          MiniFiles.open(buf_dir)
        else
          MiniFiles.open()
        end
      end, { desc = "[O]pen [F]ile tree" })

      -- snippet taken from docs:
      -- https://github.com/echasnovski/mini.nvim/blob/fcf982a66df4c9e7ebb31a6a01c604caee2cd488/doc/mini-files.txt#L475
      local map_split = function(buf_id, lhs, direction)
        local rhs = function()
          -- Make new window and set it as target
          local cur_target = MiniFiles.get_explorer_state().target_window
          local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. " split")
            return vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target)
          MiniFiles.go_in()
          MiniFiles.close()
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = "Split " .. direction
        vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
      end

      local function sync_and_close()
        MiniFiles.synchronize()
        MiniFiles.close()
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "ZZ", sync_and_close, { buffer = buf_id })
          vim.keymap.set("n", "<esc>", sync_and_close, { buffer = buf_id })
          map_split(buf_id, "<leader>s", "belowright horizontal")
          map_split(buf_id, "<C-e>", "belowright horizontal")
          map_split(buf_id, "<C-v>", "belowright vertical")
          map_split(buf_id, "<leader>v", "belowright vertical")
        end,
      })

      require("mini.surround").setup({
        n_lines = 100,
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

      local mini_misc = require("mini.misc")
      local fallback = function(buf_path)
        -- Just cd to the parent folder if you can't find a root marker
        return vim.fn.fnamemodify(buf_path, ":h")
      end
      mini_misc.setup_auto_root({ ".git", "package.json", "Makefile" }, fallback)

      require("mini.git").setup()
      vim.keymap.set("n", "<Leader>G", ":Git ", { desc = ":Git " })

      require("mini.bracketed").setup()
      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
      require("mini.operators").setup()
    end,
  },
}
