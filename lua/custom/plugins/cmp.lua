local custom_vars = require("custom.vars")

return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*",
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip",

    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",

    -- Adds a number of user-friendly snippets
    "rafamadriz/friendly-snippets",

    -- Automatically close symbols like ", ', (, etc.
    "windwp/nvim-autopairs",

    -- Add completion from buffer contents / nearby file paths
    "hrsh7th/cmp-buffer",
    "FelipeLema/cmp-async-path",

    -- Misc
    "mtoohey31/cmp-fish",
    "hrsh7th/cmp-emoji",
    "davidsierradz/cmp-conventionalcommits",
    {
      "zbirenbaum/copilot-cmp",
      dependencies = { "zbirenbaum/copilot.lua" },
      event = "InsertEnter",
      cmd = "Copilot",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
          filetypes = {
            yaml = true,
          },
        })
        require("copilot_cmp").setup({})
      end,
      enabled = custom_vars.copilot_enabled,
    },
    {
      "Exafunction/codeium.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
      },
      event = "InsertEnter",
      config = function()
        require("codeium").setup({})
      end,
      enabled = custom_vars.codeium_enabled,
    },
  },
  config = function()
    -- [[ Configure nvim-cmp ]]
    -- See `:help cmp`
    local cmp = require("cmp")
    require("nvim-autopairs").setup({})
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({})

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- Preselect keeps the lsp from choosing an option for you.
      preselect = cmp.PreselectMode.None,
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-a>"] = cmp.mapping.complete({ config = { sources = { name = "copilot" } } }),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-Esc>"] = cmp.mapping.abort(),
        ["<Esc>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- this is useful when confirming the selection triggers some
            -- behavior, like gopls importing a module
            cmp.mapping.confirm()
            vim.schedule(fallback)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ["<C-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Down>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<Up>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "luasnip" },
        { name = "copilot" },
        { name = "codeium" },
        { name = "fish" },
        { name = "buffer" },
        { name = "async_path" },
        { name = "emoji" },
      },
    })
  end,
}
