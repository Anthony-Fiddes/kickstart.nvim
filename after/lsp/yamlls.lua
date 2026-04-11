local config = require("config")

return {
  settings = {
    yaml = {
      customTags = { "!reference sequence" },
      schemas = config.yaml_schemas or nil,
    },
  },
}
