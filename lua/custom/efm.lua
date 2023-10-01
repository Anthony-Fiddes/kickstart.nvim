local eslint = require('efmls-configs.linters.eslint')
local prettier = require('efmls-configs.formatters.prettier')
local stylua = require('efmls-configs.formatters.stylua')
local gofmt = require('efmls-configs.formatters.gofmt')
local goimports = require('efmls-configs.formatters.goimports')
local black = require('efmls-configs.formatters.black')
local yamllint = require('efmls-configs.linters.yamllint')
local fish = require('efmls-configs.linters.fish')
local fish_indent = require('efmls-configs.formatters.fish_indent')

local languages = {
	fish = { fish, fish_indent },
	go = { gofmt, goimports },
	lua = { stylua },
	python = { black },
	typescript = { eslint, prettier },
	javascript = { eslint, prettier },
	json = { prettier },
	yaml = { yamllint },
}

local efmls_config = {
	filetypes = vim.tbl_keys(languages),
	rootMarkers = { '.git/' },
	languages = languages,
	init_options = {
		documentFormatting = true,
		documentRangeFormatting = true,
	},
}

return efmls_config
