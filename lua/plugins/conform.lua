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
    {
      "<leader>tf",
      function()
        vim.b.autoformat_enabled = not vim.b.autoformat_enabled
        if vim.b.autoformat_enabled then
          vim.notify("Format on save enabled")
        else
          vim.notify("Format on save disabled")
        end
      end,
      desc = "[T]oggle [F]ormatting on Save",
    },
  },
  config = function()
    local formatting = require("config").formatting
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
        -- the go formatters tend to time out a lot, so just run them asynchronously
        go = { "goimports", "golines", "gofumpt", format_after_save = true },
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
