local config = require("config")

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
    "onsails/lspkind.nvim",
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
      enabled = config.ai.copilot_enabled,
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
      enabled = config.ai.codeium_enabled,
    },
    {
      "supermaven-inc/supermaven-nvim",
      enabled = config.ai.supermaven_enabled,
      event = "InsertEnter",
      config = function()
        require("supermaven-nvim").setup({
          disable_keymaps = true,
          disable_inline_completion = true,
        })
      end,
      condition = function()
        -- only allow supermaven in git repos
        if require("mini.misc").find_root(0, { ".git" }) ~= nil then
          return false
        end
        -- stop supermaven
        return true
      end,
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

    -- taken from
    -- https://github.com/zbirenbaum/copilot-cmp#tab-completion-configuration-highly-recommended
    local has_words_before = function()
      if vim.bo.buftype == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
    end

    local lspkind = require("lspkind")
    lspkind.init({
      symbol_map = {
        Codeium = "󰚩",
        Copilot = "󰚩",
        Supermaven = "󰚩",
      },
    })

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
        ["<C-a>"] = cmp.mapping.complete({ config = { sources = { { name = "copilot" } } } }),
        ["<C-Space>"] = cmp.mapping.complete({}),
        ["<C-Esc>"] = cmp.mapping.abort(),
        -- inspired by https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
        ["<CR>"] = cmp.mapping(function(fallback)
          if not cmp.visible() then
            fallback()
            return
          end

          if luasnip.expandable() then
            luasnip.expand()
          elseif cmp.get_active_entry() then
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = false,
            })
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-y>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() and has_words_before() then
            cmp.select_next_item()
          elseif luasnip.locally_jumpable(1) then
            luasnip.jump(1)
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
        { name = "codeium" },
        { name = "copilot" },
        { name = "supermaven" },
        { name = "fish" },
        require("config.cmp").sources.buffer,
        { name = "async_path" },
        { name = "emoji" },
      },
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text", -- show only symbol annotations
          maxwidth = {
            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- menu = function() return math.floor(0.45 * vim.o.columns) end,
            menu = 50, -- leading text (labelDetails)
            abbr = 50, -- actual suggestion item
          },
          ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true, -- show labelDetails in menu. Disabled by default
        }),
      },
    })
  end,
}
