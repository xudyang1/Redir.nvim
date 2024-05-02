local Config = require("redir.config")
local View = require("redir.view")

local function setup(opts)
  Config.setup(opts)
  View.setup()
end

return {
  setup = setup,
  open_win = View.open_win,
  open_float = View.open_float,
  open_vertical = View.open_vertical,
  open_horizontal = View.open_horizontal,
  open_tab = View.open_tab,
  close_win = View.close_win,
}
