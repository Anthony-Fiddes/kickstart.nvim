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

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

local mason_lspconfig = require("mason-lspconfig")
-- ensure that the servers that don't scream at you are installed
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
  },
})

-- TODO: ensure that on_attach and capabilities are correct
vim.lsp.enable({
  "bashls",
  "dockerls",
  "docker_compose_language_service",
  "gitlab_ci_ls",
  "gopls",
  "helm_ls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "pylsp",
  "ruff",
  "terrformls",
  "ts_ls",
  "vue_ls",
  "yamlls",
})
