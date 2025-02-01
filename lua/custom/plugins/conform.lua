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
    vim.keymap.set("n", "<leader>tf", function()
      vim.b.autoformat_enabled = not vim.b.autoformat_enabled
      if vim.b.autoformat_enabled then
        print("Format on save enabled")
      else
        print("Format on save disabled")
      end
    end, { desc = "[T]oggle [F]ormatting on Save" })

    local formatting = require("custom.vars").formatting
    require("conform").setup({
      format_on_save = function(bufnr)
        if vim.b[bufnr].autoformat_enabled == nil then
          -- Determine autoformat default value
          if formatting.ignored_files[vim.fn.expand("%t")] then
            vim.b[bufnr].autoformat_enabled = false
          else
            vim.b[bufnr].autoformat_enabled = formatting.on_save
          end
        end

        if not vim.b[bufnr].autoformat_enabled then
          return
        end
        return {
          timeout_ms = 500,
          lsp_format = "fallback",
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
        yaml = { "prettier" },
        -- for all filetypes without a formatter
        ["_"] = { "trim_whitespace" },
      },
    })
  end,
}
