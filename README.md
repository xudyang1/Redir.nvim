<!-- markdownlint-disable MD013 -->

# Redir

Redirects neovim's [cmdline](https://neovim.io/doc/user/cmdline.html) output to a modifiable buffer.

## Features

- multiple layouts: vertical/horizontal split, floating window, tab window
- allows quick copying, editing, and searching of text on the output buffer
- keeps a history of input and output on the buffer for the entire session
- switch between layouts
- supports all `Ex` commands

## Requirements

- Latest stable neovim (v0.10.1)

## Installation

- [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
    "xudyang1/redir.nvim",
    opts = {
      -- your configuration options...
      -- leave it empty to use the default settings
      -- refer to the configuration section below
    }
}
```

## Configuration

### A complete list of configuration options and default values

```lua
---@class RedirOptions
---@field buffer_name? string Buffer name displayed
---@field layout_style? LayoutStyle Output window layout style
---@field output_format? RedirOutputFormat By default, input cmd is inserted as a header.
---@field attach? fun(burnr: integer) Called after opening the redir buffer
---@field layout_config? RedirLayoutConfig Layout specific configuration, overwrite globals
{
  buffer_name = "Redir",
  ---@type "horizontal" | "vertical" | "float" | "tab" Default layout style
  layout_style = "horizontal",
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
```

## Usage

### Commands

Example keybindings:

```lua
-- Lua
vim.keymap.set("n", "<Leader>tr", function() require("redir").toggle() end, { desc = "Redir: toggle"})
vim.keymap.set("n", "<Leader>re", function() require("redir").open() end, { desc = "Redir: open win"})
vim.keymap.set("n", "<Leader>rh", function() require("redir").open_horizontal() end, { desc = "Redir: open horizontal"})
vim.keymap.set("n", "<Leader>rv", function() require("redir").open_vertical() end, { desc = "Redir: open vertical"})
vim.keymap.set("n", "<Leader>rf", function() require("redir").open_float() end, { desc = "Redir: open float"})
vim.keymap.set("n", "<Leader>rt", function() require("redir").open_tab() end, { desc = "Redir: open tab"})
vim.keymap.set("n", "<Leader>rc", function() require("redir").close() end, { desc = "Redir: close win"})
```
