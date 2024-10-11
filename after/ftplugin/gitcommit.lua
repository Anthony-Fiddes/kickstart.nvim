require("cmp").setup.buffer({
  sources = require("cmp").config.sources({
    { name = "conventionalcommits" },
    { name = "buffer" },
    { name = "luasnip" },
    { name = "copilot" },
    { name = "codeium" },
  }),
})
