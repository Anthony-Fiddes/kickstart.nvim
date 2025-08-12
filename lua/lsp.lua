local config = require("config")

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
---@param client vim.lsp.Client
local on_attach = function(client, bufnr)
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local map_func = function(mode)
    ---@param keys string
    ---@param func string | function
    ---@param desc string
    ---@param nowait boolean?
    return function(keys, func, desc, nowait)
      if desc then
        desc = "LSP: " .. desc
      end
      vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc, nowait = nowait })
    end
  end
  local nmap = map_func("n")

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

  local jump_to_single_result = function(func)
    return function()
      -- undocumented functionality of fzf-lua that I found from looking at
      -- LazyVim config.
      func({ jump1 = true, ignore_current_line = true })
    end
  end
  local fzf = require("fzf-lua")
  nmap("gd", jump_to_single_result(fzf.lsp_definitions), "[G]oto [D]efinition")
  nmap("gr", jump_to_single_result(fzf.lsp_references), "[G]oto [R]eferences", true)
  nmap("gi", jump_to_single_result(fzf.lsp_implementations), "[G]oto [I]mplementation")
  nmap("<leader>fs", fzf.lsp_live_workspace_symbols, "[F]ind [S]ymbols")
  nmap("<leader>fS", fzf.lsp_document_symbols, "[F]ind Document [S]ymbols")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
  nmap("<leader>ca", fzf.lsp_code_actions, "[C]ode [A]ction")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>Wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>Wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>Wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    nmap("<leader>ti", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, "[T]oggle [I]nlay Hints")
    -- hints enabled by default
    vim.lsp.inlay_hint.enable()
  end

  -- Don't let ruff try to give hover information in favor of pylsp
  -- If I end up needing to do this with other LSPs, I should add a table in
  -- config.
  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end

  -- For some reason, vue_ls takes over these capabilities from ts_ls, causing
  -- time outs on vue_ls when trying to go to definition and completely removing
  -- hover support. I think it's a bug and will file a report if I find the
  -- time.
  if client.name == "volar" or client.name == "vue_ls" then
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.hoverProvider = false
  end
end

-- It's very important to do these steps in this order before setting up servers
-- using lspconfig.
require("mason").setup()
require("mason-lspconfig").setup()

-- only works with Mason v1,
local mason_registry = require("mason-registry")
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}

--  NOTE: The contents of the following map will be passed to the `settings`
--  field of the server config. You must look up that documentation yourself.

local settings = {
  bashls = {},
  dockerls = {},
  docker_compose_language_service = {},
  gopls = {
    gopls = {
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = false,
        compositeLiteralFields = true,
        compositeLiteralTypes = false,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      gofumpt = true,
      -- consider adding support for semantic tokens?
    },
  },
  gitlab_ci_ls = {},
  helm_ls = {},
  html = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = {
        disable = { "missing-fields", "inject-field" },
      },
      hint = {
        enable = true,
        setType = "Disable",
        paramType = true,
        paramName = true,
        semicolon = "Disable",
        arrayIndex = "Disable",
      },
    },
  },
  marksman = {},
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
  ruff = {},
  -- you have to install this via the :LspInstall command for it to be properly
  -- setup by mason-lspconfig! This may be something to improve upon.
  terraformls = {},
  ts_ls = {},
  vue_ls = {},
  yamlls = {
    yaml = {
      customTags = { "!reference sequence" },
      schemas = config.yaml_schemas or nil,
    },
  },
}

local filetypes = {
  ts_ls = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}

local init_options = {
  ts_ls = {
    preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayVariableTypeHints = false,
      includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayEnumMemberValueHints = true,
      importModuleSpecifierPreference = "non-relative",
    },
    plugins = {
      vue_plugin,
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
    "lua_ls",
  },
})
mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = settings[server_name],
      filetypes = filetypes[server_name],
      init_options = init_options[server_name],
    })
  end,
})
