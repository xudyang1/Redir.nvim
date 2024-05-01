-- TODO:
-- nvim_create_namspace?
-- color text warn yellow, error red?
-- schema validation?
-- layout switching?
-- message type filtering (success, warn, error)?
-- tests

local Constants = require("redir.constants")

---@class RedirConfig
---@field version string
---@field options RedirOptions
local RedirConfig = {
  version = "0.0.1",
}

---@class RedirOptions
---@field layout_style LayoutStyle output window layout style
---@field output_format RedirOutputFormat by default, input cmd is inserted as a header.
---@field prompt RedirPrompt configure input prompt
---@field layout_config RedirLayoutConfig layout specific configuration, overwrite globals
local defaults = {
  layout_style = Constants.LayoutStyle.horizontal,
  ---@class RedirOutputFormat
  ---@field header boolean | string | fun(opts: table): string insert a header before each output body
  ---@field footer boolean | string | fun(opts: table): string insert a footer after each output body
  output_format = {
    ---@param opts table @see nvim_parse_cmd()
    header = function(opts)
      local time = vim.fn.strftime("%T")
      local format = "================== " .. time .. " ==================\n"
      return format .. opts.cmd
    end,
    footer = false,
  },
  ---@class RedirPrompt
  ---@field prompt_style PromptStyle "cmdline" in the native cmdline, or "float" in a floating window
  ---@field prompt_string string prompt string
  prompt = {
    prompt_style = Constants.PromptStyle.cmdline,
    prompt_string = "Redir",
    -- display_CR?
  },
  ---@class RedirLayoutConfig
  ---@field vertical RedirLayoutVertical vertical layout style options
  ---@field horizontal RedirLayoutHorizontal horizontal layout style options
  ---@field float RedirLayoutFloat floating layout style options
  ---@field tab RedirLayoutTab tab layout style options
  layout_config = {
    ---@class RedirLayoutVertical
    vertical = {
      --orientation?
      -- width?
    },
    ---@class RedirLayoutHorizontal
    horizontal = {
      --orientation?
      --height?
    },
    ---@alias BorderStyleArray string[] a char array of length 8 or any divisor of 8 @see |nvim_open_win()|
    ---@alias BorderStyle "none" | "single" | "double" | "rounded" | "solid" | "shadow" | BorderStyleArray
    ---@class RedirLayoutFloat
    ---@field width number percentage of screen width if value <= 1; or, number of columns if width > 1
    ---@field height number percentage of screen height if value <= 1; or, number of lines if height > 1
    ---@field border BorderStyle set border style @see :help nvim_open_win() for detail
    ---@field title string | fun(): string set a custom title of the floating window
    ---@field title_pos "left" | "center" | "right" position of title
    float = {
      width = 0.6,
      height = 0.6,
      border = "rounded",
      title = "Redir Message",
      title_pos = "center",
      -- TODO: add auto_cmd executed after entering the buffer
    },
    ---@class RedirLayoutTab
    tab = {},
  },
}

---setup configuration options
---@param opts? RedirOptions
function RedirConfig.setup(opts)
  opts = opts or {}
  RedirConfig.options = vim.tbl_deep_extend("force", defaults, opts)
end

return RedirConfig
