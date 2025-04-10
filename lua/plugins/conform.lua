return { -- Autoformat
  "stevearc/conform.nvim",
  event = { "BufRead", "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fo",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "x" },
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
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        css = { "prettier" },
        fish = { "fish_indent" },
        -- the go formatters tend to time out a lot, so just run them asynchronously
        go = { "goimports", "golines", "gofumpt", format_after_save = true, timeout_ms = 1000 },
        hcl = { "packer_fmt" },
        lua = { "stylua" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        python = { "isort", lsp_format = "last" },
        yaml = { "prettier" },
      },
    })

    local augroup = vim.api.nvim_create_augroup("format-on-save", { clear = true })
    vim.api.nvim_create_autocmd("BufRead", {
      pattern = "*",
      group = augroup,
      callback = function(args)
        -- Determine autoformat default value
        if vim.b[args.buf].autoformat_enabled == nil then
          if formatting.ignored_files[vim.fn.expand("%t")] then
            vim.b[args.buf].autoformat_enabled = false
          else
            vim.b[args.buf].autoformat_enabled = formatting.on_save
          end
        end
      end,
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*",
      group = augroup,
      callback = function(args)
        -- trim whitespace no matter what
        conform.format({ bufnr = args.buf, formatters = { "trim_whitespace" } })

        -- Only format on save if autoformat is enabled for the buffer
        if not vim.b[args.buf].autoformat_enabled then
          return
        end
        conform.format({
          bufnr = args.buf,
          timeout_ms = 500,
          lsp_format = "fallback",
        })
      end,
    })
  end,
}
