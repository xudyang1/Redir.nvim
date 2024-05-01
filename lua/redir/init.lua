local Config = require("redir.config")
local View = require("redir.view")

local Redir = {}

function Redir.setup(opts)
  Config.setup(opts)
  View.setup()
end

function Redir.open_win()
  View:open_win()
end

function Redir.open_float()
  View:open_float()
end

function Redir.open_vertical()
  View:open_vertical()
end

function Redir.open_horizontal()
  View:open_horizontal()
end

function Redir.open_tab()
  View:open_tab()
end

return Redir
