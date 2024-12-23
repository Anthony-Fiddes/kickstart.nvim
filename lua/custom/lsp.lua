local custom_vars = require("custom.vars")

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
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
  local vmap = map_func("v")

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

  local jump_to_single_result = function(func)
    return function()
      -- undocumented functionality of fzf-lua that I found from looking at
      -- LazyVim config.
      func({ jump_to_single_result = true, ignore_current_line = true })
    end
  end
  local fzf = require("fzf-lua")
  nmap("gd", jump_to_single_result(fzf.lsp_definitions), "[G]oto [R]eferences")
  nmap("gr", jump_to_single_result(fzf.lsp_references), "[G]oto [R]eferences", true)
  nmap("gi", jump_to_single_result(fzf.lsp_implementations), "[G]oto [I]mplementation")
  nmap("<leader>fs", fzf.lsp_workspace_symbols, "[F]ind [S]ymbols")
  nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
  nmap("<leader>ca", fzf.lsp_code_actions, "[C]ode [A]ction")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  local format_buffer = function()
    vim.lsp.buf.format({
      filter = function(client)
        return not custom_vars.formatting.banned_lsps[client.name]
      end,
    })
  end

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", format_buffer, { desc = "Format current buffer with LSP" })
  nmap("<leader>fo", ":Format<CR>", "[Fo]rmat")
  vmap("<leader>fo", format_buffer, "[Fo]rmat")

  -- Don't let ruff try to give hover information in favor of pylsp
  -- If I end up needing to do this with other LSPs, I should add a table in
  -- custom_vars.
  if client.name == "ruff" then
    client.server_capabilities.hoverProvider = false
  end
end

-- It's very important to do these steps in this order before setting up servers
-- using lspconfig.
require("mason").setup()
require("mason-lspconfig").setup()

--  NOTE: The contents of the following map will be passed to the `settings`
--  field of the server config. You must look up that documentation yourself.

local efm_lsp = require("custom.efm")
local settings = {
  bashls = {},
  dockerls = {},
  docker_compose_language_service = {},
  efm = efm_lsp.settings,
  gopls = {},
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
  ts_ls = {},
  yamlls = {
    yaml = {
      customTags = { "!reference sequence" },
      schemas = custom_vars.yaml_schemas or nil,
    },
  },
}

local filetypes = {
  efm = efm_lsp.filetypes,
}

local init_options = {
  efm = efm_lsp.init_options,
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
      settings = settings[server_name],
      filetypes = filetypes[server_name],
      init_options = init_options[server_name],
    })
  end,
})
