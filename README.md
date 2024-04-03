<!-- markdownlint-disable MD013 -->

# Redir

Redirects neovim [cmdline](https://neovim.io/doc/user/cmdline.html) output to a modifiable buffer.

## Features

- uses a floating window to redirect cmdline output
- supports all `Ex` command
- keeps history for entire session including
  - command inputs
  - message outputs
- output window reopen
- customizable line separator

## Requirements

- Neovim >= 0.7.2
- Optional: a [patched](https://www.nerdfonts.com/) font for better line separator visualization

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
    -- TODO: add list
}
```

## Usage

### Commands

Example keybindings:

```lua
-- TODO: add examples
```

### API

You can configure following functions in your keybindings

```lua
-- TODO: add examples
```

## Known Issues

If you use [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) to enable autocompletion in cmdline mode, please note that you may experience input hanging with `Redir !shellcmd`.

For example:

```txt
:Redir !ls # <- input hanging may occur, press ctrl-c to kill the cmp-cmdline completion process
```

This is a known bug in [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline/issues/109)
