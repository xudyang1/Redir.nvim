---@diagnostic disable-next-line: undefined-field
local project_root_dir = vim.uv.cwd() .. "/"

local function load_package(plugin)
  local plugin_name = plugin:match(".*/(.*)")
  local installed_parent_dir = project_root_dir .. ".tests/pack/start/"
  local plugin_installed_path = installed_parent_dir .. plugin_name
  ---@diagnostic disable-next-line: undefined-field
  if not (vim.uv or vim.loop).fs_stat(plugin_installed_path) then
    print("Installing package " .. plugin .. "...")
    vim.fn.mkdir(installed_parent_dir, "p")
    vim.fn.system({
      "git",
      "clone",
      "--depth=1",
      "https://github.com/" .. plugin .. ".git",
      plugin_installed_path,
    })
  end
end

local function setup()
  vim.cmd([[set runtimepath=$VIMRUNTIME]])
  local testing_dir = project_root_dir .. ".tests/"

  vim.opt.runtimepath:append(project_root_dir)
  vim.opt.packpath = { testing_dir .. "pack" }

  load_package("nvim-lua/plenary.nvim")

  vim.env.XDG_CONFIG_HOME = testing_dir .. "config"
  vim.env.XDG_DATA_HOME = testing_dir .. "data"
  vim.env.XDG_STATE_HOME = testing_dir .. "state"
  vim.env.XDG_CACHE_HOME = testing_dir .. "cache"
end

setup()
