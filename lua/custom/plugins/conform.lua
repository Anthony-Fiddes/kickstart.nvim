return { -- Autoformat
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fo",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  config = function()
    -- Add a buffer variable that determines whether or not to format on save
    local formatting = require("custom.vars").formatting
    local augroup = vim.api.nvim_create_augroup("set_autoformat_buffer_variable", { clear = true })
    vim.api.nvim_create_autocmd("BufNew", {
      group = augroup,
      callback = function(args)
        local bufnr = args.buf
        -- Determine autoformat default value
        if vim.b[bufnr].autoformat_enabled == nil then
          if formatting.ignored_files[vim.fn.expand("%t")] then
            vim.b[bufnr].autoformat_enabled = false
          end
          vim.b[bufnr].autoformat_enabled = formatting.on_save
        end
      end,
    })
    vim.keymap.set("n", "<leader>tf", function()
      vim.b.autoformat_enabled = not vim.b.autoformat_enabled
      if vim.b.autoformat_enabled then
        print("Format on save enabled")
      else
        print("Format on save disabled")
      end
    end, { desc = "[T]oggle [F]ormatting on Save" })

    require("conform").setup({
      notify_on_error = false,
      format_on_save = function(bufnr)
        local lsp_format_opt
        if vim.b[bufnr].autoformat_enabled then
          lsp_format_opt = "never"
        else
          lsp_format_opt = "fallback"
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        css = { "prettier" },
        fish = { "fish_indent" },
        go = { "goimports", "golines", "gofumpt" },
        lua = { "stylua" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        python = { "isort", lsp_format = "last" },
      },
    })
  end,
}
