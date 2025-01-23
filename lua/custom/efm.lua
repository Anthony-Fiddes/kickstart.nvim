local eslint = require("efmls-configs.linters.eslint")
local yamllint = require("efmls-configs.linters.yamllint")
local fish = require("efmls-configs.linters.fish")
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
  dockerfile = { hadolint },
  fish = { fish },
  gitcommit = { gitlint },
  typescript = { eslint },
  typescriptreact = { eslint },
  javascript = { eslint },
  sql = { sqlfluff },
  yaml = { yamllint },
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
