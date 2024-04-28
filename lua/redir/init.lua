local Config = require("redir.config")

local function setup(opts)
  Config.setup(opts)
end

return {
  setup = setup,
}
