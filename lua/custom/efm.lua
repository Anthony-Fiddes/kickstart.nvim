local eslint = require("efmls-configs.linters.eslint")
local prettier = require("efmls-configs.formatters.prettier")
local stylua = require("efmls-configs.formatters.stylua")
local gofmt = require("efmls-configs.formatters.gofmt")
local goimports = require("efmls-configs.formatters.goimports")
local golines = require("efmls-configs.formatters.golines")
local isort = require("efmls-configs.formatters.isort")
local yamllint = require("efmls-configs.linters.yamllint")
local fish = require("efmls-configs.linters.fish")
local fish_indent = require("efmls-configs.formatters.fish_indent")
local sqlfluff = require("efmls-configs.linters.sqlfluff")
local hadolint = require("efmls-configs.linters.hadolint")
local gitlint = require("efmls-configs.linters.gitlint")

-- Extensions/overrides
local fs = require("efmls-configs.fs")

local which_sqlfluff = fs.executable("sqlfluff")
-- I'd prefer that dialect was set from the nearest sqlfluff file
local sqlfluff_command =
  string.format("%s lint --format github-annotation-native --annotation-level warning --nocolor --disable-progress-bar ${INPUT}", which_sqlfluff)
sqlfluff = vim.tbl_extend("force", sqlfluff, { lintCommand = sqlfluff_command })

local languages = {
  css = { prettier },
  dockerfile = { hadolint },
  fish = { fish, fish_indent },
  go = { gofmt, goimports, golines },
  gitcommit = { gitlint },
  lua = { stylua },
  python = { isort },
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  javascript = { eslint, prettier },
  json = { prettier },
  markdown = { prettier },
  sql = { sqlfluff },
  yaml = { yamllint, prettier },
}

local efmls_config = {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git/" },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}

return efmls_config
