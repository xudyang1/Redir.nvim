-- TODO:
-- schema validation?
-- nvim_create_namspace? if autocmd used
-- color virtual text warn yellow, error red?
-- message type filtering (success(info), warn, error)?

local Constants = require("redir.constants")

---@class RedirConfig
---@field version string
---@field options RedirOptions
local Config = {
  version = "0.0.1",
}

---@class RedirOptions
---@field buffer_name? string Buffer name displayed
---@field layout_style? LayoutStyle Output window layout style
---@field output_format? RedirOutputFormat By default, input cmd is inserted as a header.
---@field attach? fun(burnr: integer) Called after opening the redir buffer
---@field layout_config? RedirLayoutConfig Layout specific configuration, overwrite globals
-- TODO: ---@field prompt? RedirPrompt configure input prompt
Config.defaults = {
  buffer_name = "Redir",
  layout_style = Constants.LayoutStyle.horizontal,
  ---@class RedirOutputFormat
  ---@field header? SeparatorWrapper Content separator before each output body
  ---@field footer? SeparatorWrapper Content separator after each output body
  output_format = {
    ---@alias Separator string | fun(opts: table): string?
    ---@class SeparatorWrapper
    ---@field enabled? boolean Enable or disable the separator
    ---@field separator? Separator Content of the separator
    header = {
      enabled = true,
      ---@param opts table A single table argument used in command function from vim.api.nvim_create_user_command
      separator = function(opts)
        if opts.fargs[1] and string.sub(opts.fargs[1], 1, 1) == "!" then
          return
        end
        return opts.args
      end,
    },
    ---@class SeparatorWrapper
    footer = {
      enabled = false,
      separator = nil,
    },
  },
  attach = nil,
  -- ---@class RedirPrompt
  -- ---@field prompt_style? PromptStyle
  -- ---@field prompt_string? String
  -- prompt = {
  --   prompt_style = Constants.PromptStyle.cmdline,
  --   prompt_string = "Redir",
  --   -- display_CR?
  -- },
  ---@class RedirLayoutConfig
  ---@field vertical? RedirLayoutVertical Vertical layout style options
  ---@field horizontal? RedirLayoutHorizontal Horizontal layout style options
  ---@field float? RedirLayoutFloat Floating layout style options
  ---@field tab? RedirLayoutTab Tab layout style options
  layout_config = {
    ---@class RedirLayoutVertical
    ---@field width? number Percentage of screen width if value <= 1; or, number of columns if width > 1
    vertical = {
      width = nil,
    },
    ---@class RedirLayoutHorizontal
    ---@field height? number Percentage of screen height if value <= 1; or, number of lines if height > 1
    horizontal = {
      height = nil,
    },
    ---@class RedirLayoutFloat
    ---@field win_opts? WinConfig Partial of vim.api.keyset.win_config, @see nvim_open_win
    float = {
      ---@alias BorderCharArray string[] A char array of length 8 or any divisor of 8 @see |nvim_open_win()|
      ---@alias BorderStyle "none" | "single" | "double" | "rounded" | "solid" | "shadow" | BorderCharArray
      ---@class WinConfig
      ---@field width? number Percentage of screen width if value <= 1; or, number of columns if width > 1
      ---@field height? number Percentage of screen height if value <= 1; or, number of lines if height > 1
      ---@field border? BorderStyle Set border style @see :help nvim_open_win() for detail
      ---@field title? string | fun(): string Set a custom title of the floating window
      ---@field title_pos? "left" | "center" | "right" Position of title
      win_opts = {
        width = 0.6,
        height = 0.6,
        border = "rounded",
        title = "Redir Message",
        title_pos = "center",
      },
    },
    ---@class RedirLayoutTab
    tab = {},
  },
}

---setup configuration options
---@param opts? RedirOptions
function Config.setup(opts)
  opts = opts or {}
  if Config.options == nil then
    Config.options = Config.defaults
  end
  Config.options = vim.tbl_deep_extend("force", Config.options, opts)
end

return Config
