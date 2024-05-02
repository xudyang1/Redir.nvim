<!-- markdownlint-disable MD013 -->

# Redir

Redirects neovim [cmdline](https://neovim.io/doc/user/cmdline.html) output to a modifiable buffer.

## Features

- multiple layouts: vertical/horizontal split, floating window, tab window
- allows quick copying, editing, and searching of text on the output buffer
- keeps a history of input and output on the buffer for the entire session
- switch between layouts
- supports all `Ex` commands

## Requirements

- Neovim >= 0.8.0

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
{
  -- output window layout: "vertical", "horizontal", "float", "tab"
  layout_style = "horizontal",
  ---@class RedirOutputFormat
  ---@field header boolean | string | fun(opts: table): string insert a header before each output body
  ---@field footer boolean | string | fun(opts: table): string insert a footer after each output body
  output_format = {
    ---@param opts table @see nvim_parse_cmd()
    header = function(opts)
      return opts.cmd
    end,
    footer = false,
  },
  ---@class RedirLayoutConfig
  ---@field vertical RedirLayoutVertical vertical layout style options
  ---@field horizontal RedirLayoutHorizontal horizontal layout style options
  ---@field float RedirLayoutFloat floating layout style options
  ---@field tab RedirLayoutTab tab layout style options
  layout_config = {
    ---@class RedirLayoutVertical
    vertical = {
    },
    ---@class RedirLayoutHorizontal
    horizontal = {
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
    },
    ---@class RedirLayoutTab
    tab = {},
  }
}
```

## Usage

### Commands

Example keybindings:

```lua
-- Lua
vim.keymap.set("n", "<Leader>re", require("redir").open_win, { desc = "Redir: open win"})
vim.keymap.set("n", "<Leader>rh", require("redir").open_horizontal, { desc = "Redir: open horizontal"})
vim.keymap.set("n", "<Leader>rv", require("redir").open_vertical, { desc = "Redir: open vertical"})
vim.keymap.set("n", "<Leader>rf", require("redir").open_float, { desc = "Redir: open float"})
vim.keymap.set("n", "<Leader>rt", require("redir").open_tab, { desc = "Redir: open tab"})
-- you can use `:q` instead of the following keymap
vim.keymap.set("n", "<Leader>rc", require("redir").close_win, { desc = "Redir: close win"})
```

## Known Issues

If you use [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) to enable autocompletion in cmdline mode, please note that you may experience input hanging with `Redir !shellcmd`.

For example:

```txt
:Redir !ls # <- input hanging may occur, press ctrl-c to kill the cmp-cmdline completion process
```

This is a known bug in [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline/issues/109)
