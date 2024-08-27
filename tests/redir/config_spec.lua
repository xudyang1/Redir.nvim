local Redir = require("redir")
local Config = require("redir.config")
local Constants = require("redir.constants")

describe("redir.setup", function()
  local default_config = vim.deepcopy(Config.defaults)

  before_each(function()
    Config.options = nil
  end)

  it("should use default options with no argument", function()
    Redir.setup()
    assert.are_same(default_config, Redir.config.options)
  end)

  it("should use default options with {}", function()
    Redir.setup({})
    assert.are_same(default_config, Redir.config.options)
  end)

  it("should use merged options with custom arguments", function()
    local opts = {
      layout_style = Constants.LayoutStyle.vertical,
      layout_config = {
        vertical = {
          width = 100,
        },
        horizontal = {
          height = 30,
        },
        float = {
          win_opts = {
            width = 40,
            height = 40,
            border = "single",
            title = "test",
            title_pos = "center",
          },
        },
      },
    }
    Redir.setup(opts)
    local expected = vim.tbl_deep_extend("force", default_config, opts)
    assert.are_same(expected, Redir.config.options)
  end)
end)
