-- TODO:
-- nvim_create_namspace?
-- color text warn yellow, error red?
-- schema validation?
-- layout switching?
-- message type filtering (success, warn, error)?
-- tests

local Constants = require("redir.constants")

local RedirConfig = {
  version = "0.0.1",
}

local defaults = {
  layout_style = Constants.LayoutStyle.horizontal,
  output_format = {
  prompt = {
    prompt_style = Constants.PromptStyle.cmdline,
    prompt_string = "Redir",
    -- display_CR?
  },
  layout_config = {
    vertical = {
      --orientation?
      -- width?
    },
    horizontal = {
      --orientation?
      --height?
    },
    float = {
      width = 0.6,
      height = 0.6,
      border = "rounded",
      title = "Redir Message",
      title_pos = "center",
      -- TODO: add auto_cmd executed after entering the buffer
    },
    tab = {},
  },
}

function RedirConfig.setup(opts)
  opts = opts or {}
  RedirConfig.options = vim.tbl_deep_extend("force", defaults, opts)
end

return RedirConfig
