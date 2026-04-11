return {
  settings = {
    Lua = {
      codeLens = { enable = true },
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
}
