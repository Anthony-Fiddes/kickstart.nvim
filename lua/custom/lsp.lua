local custom_vars = require("custom.vars")

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("<leader>fo", ":Format<CR>", "[Fo]rmat")

  local telescope = require("telescope.builtin")
  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("gr", telescope.lsp_references, "[G]oto [R]eferences")
  nmap("gi", telescope.lsp_implementations, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  -- TODO: do I want to be able to only look for symbols in the current buffer?
  -- I removed that because it doesn't seem super useful (unless I was working
  -- on a massive code base).
  nmap("<leader>fs", telescope.lsp_dynamic_workspace_symbols, "[F]ind [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    vim.lsp.buf.format({
      filter = function(client)
        return not custom_vars.banned_formatters[client.name]
      end,
    })
  end, { desc = "Format current buffer with LSP" })
end

-- It's very important to do these steps in this order before setting up servers
-- using lspconfig.
require("mason").setup()
require("mason-lspconfig").setup()

--  NOTE: The contents of the following map will be passed to the `settings`
--  field of the server config. You must look up that documentation yourself.

local server_settings = {
  dockerls = {},
  docker_compose_language_service = {},
  efm = require("custom.efm"),
  gopls = {},
  gitlab_ci_ls = {},
  html = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        disable = { "missing-fields", "inject-field" },
      },
    },
  },
  pylsp = {
    pylsp = {
      plugins = {
        black = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = { enabled = false },
        pylsp_mypy = { enabled = true },
      },
    },
  },
  ruff_lsp = {},
  ts_ls = {},
  yamlls = {
    yaml = {
      customTags = { "!reference sequence" },
      schemas = custom_vars.yaml_schemas or nil,
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local mason_lspconfig = require("mason-lspconfig")
-- ensure that the servers that don't scream at you are installed
mason_lspconfig.setup({
  ensure_installed = {
    "efm",
    "lua_ls",
  },
})
mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = server_settings[server_name],
    })
  end,
})
