local Config = require("redir.config")
local LayoutStyle = require("redir.constants").LayoutStyle
local Utils = require("redir.utils")
local api = vim.api

---@class RedirView
---@field win_id integer
---@field bufnr integer
---@field current_layout_style LayoutStyle
local View = {
  win_id = -1,
  bufnr = -1,
}

-- TODO: buffer_name, header, footer, attach
function View.setup()
  View.current_layout_style = Config.options.layout_style
end

---Get first valid window that has redir buffer, nil if redir buffer is not shown
---@return integer?
function View.get_first_redir_win()
  local win_id = vim.fn.win_findbuf(View.bufnr)[1]
  if win_id then
    View.win_id = win_id
  end
  return win_id
end

---Get a valid redir bufnr, or create a new scratch buffer and update View.bufnr if it is invalid
---@return integer
function View.get_or_create_redir_buf()
  if not api.nvim_buf_is_valid(View.bufnr) then
    View.bufnr = api.nvim_create_buf(false, true)
  end
  return View.bufnr
end

function View.attach()
  View.win_id = api.nvim_get_current_win()
  View.bufnr = View.get_or_create_redir_buf()
  View.win_set_redir_buf()
  local name = Config.options.buffer_name
  if name then
    api.nvim_buf_set_name(View.bufnr, name)
  end
  local attach = Config.options.attach
  if attach and type(attach) == "function" then
    attach(View.bufnr)
  end
end
---Open window with the layout from `View.current_layout_style`
function View.open()
  local layout_style = View.current_layout_style
  View["open_" .. layout_style](Config.options.layout_config[layout_style])
end

function View.close()
  local win_id = View.get_first_redir_win()
  if win_id then
    api.nvim_win_close(win_id, false)
  end
  View.win_id = -1
end

function View.toggle()
  local win_id = View.get_first_redir_win()
  if win_id then
    View.close()
  else
    View.open()
  end
end

---Set redir window with redir buffer
function View.win_set_redir_buf()
  local bufnr = View.get_or_create_redir_buf()
  api.nvim_win_set_buf(View.win_id, bufnr)
end

---Open vertical redir
---@param config RedirLayoutVertical
function View.open_vertical(config)
  local win_id = View.get_first_redir_win()
  if win_id and View.current_layout_style == LayoutStyle.vertical then
    api.nvim_set_current_win(win_id)
    return
  else
    View.close()
  end

  vim.cmd.split({ mods = { vertical = true } })
  View.current_layout_style = LayoutStyle.vertical
  View.attach()

  config = config or Config.options.layout_config.vertical
  local width = config.width
  if width then
    width = Utils.get_size(api.nvim_win_get_width(View.win_id), width)
    api.nvim_win_set_width(View.win_id, width --[[@as integer]])
  end
end

---Open horizontal redir
---@param config RedirLayoutHorizontal
function View.open_horizontal(config)
  local win_id = View.get_first_redir_win()
  if win_id and View.current_layout_style == LayoutStyle.horizontal then
    api.nvim_set_current_win(win_id)
    return
  else
    View.close()
  end

  vim.cmd.split({ mods = { vertical = false } })
  View.current_layout_style = LayoutStyle.horizontal
  View.attach()

  config = config or Config.options.layout_config.horizontal
  local height = config.height
  if height then
    height = Utils.get_size(api.nvim_win_get_height(View.win_id), height)
    api.nvim_win_set_height(View.win_id, height --[[@as integer]])
  end
end

---Open tab redir
---@param config RedirLayoutTab
-- selene: allow(unused_variable)
-- luacheck: ignore 212
---@diagnostic disable-next-line: unused-local
function View.open_tab(config)
  local win_id = View.get_first_redir_win()
  if win_id and View.current_layout_style == LayoutStyle.tab then
    api.nvim_set_current_win(win_id)
    return
  else
    View.close()
  end

  vim.cmd("tabnew")
  View.current_layout_style = LayoutStyle.tab
  View.attach()

  -- TODO: we may need config in the future
  -- config = config or config.options.layout_config.tab
end

---Open float redir
---@param config RedirLayoutFloat
function View.open_float(config)
  local win_id = View.get_first_redir_win()
  if win_id and View.current_layout_style == LayoutStyle.float then
    api.nvim_set_current_win(win_id)
    return
  else
    View.close()
  end

  config = config or Config.options.layout_config.float
  ---@type WinConfig
  local win_opts = config.win_opts

  local width = Utils.get_size(vim.o.columns, win_opts.width)
  local height = Utils.get_size(vim.o.lines, win_opts.height)

  local top = math.floor(((vim.o.lines - height) / 2))
  local left = math.floor(((vim.o.columns - width) / 2))

  -- local border = float.border or "none"
  local win_config = {
    relative = "editor",
    style = "minimal",
    title = win_opts.title,
    title_pos = win_opts.title_pos,
    width = width,
    height = height,
    row = top,
    col = left,
    border = win_opts.border,
  }

  local bufnr = View.get_or_create_redir_buf()
  api.nvim_open_win(bufnr, true, win_config)
  View.current_layout_style = LayoutStyle.float
  View.attach()
end

function View.generate_cmd_output(ctx)
  ---@type SeparatorWrapper
  local header = Config.options.output_format.header
  local header_sep
  if header.enabled then
    header_sep = header.separator
    local sep_type = type(header_sep)
    if sep_type == "function" then
      header_sep = header_sep(ctx)
    elseif sep_type ~= "string" then
      vim.notify(
        "Redir: header should be type of string or fun(table): string, but received " .. sep_type,
        vim.log.levels.ERROR
      )
      return
    end
  end
  ---@type SeparatorWrapper
  local footer = Config.options.output_format.footer
  local footer_sep
  if footer.enabled then
    footer_sep = footer.separator
    local sep_type = type(footer_sep)
    if sep_type == "function" then
      footer_sep = footer_sep(ctx)
    elseif sep_type ~= "string" then
      vim.notify(
        "Redir: footer should be type of string or fun(table): string, but received " .. sep_type,
        vim.log.levels.ERROR
      )
      return
    end
  end

  local lines = header_sep and Utils.split_lines(header_sep) or {}

  -- BUG: vim.api.nvim_parse_cmd parses `lua vim.print("abc   e  f;g")` incorrectly
  -- so that api.nvim_cmd may generate incorrect output, use api.nvim_exec2 instead
  -- local parsed_cmd = api.nvim_parse_cmd(ctx.args, {})
  -- local output = api.nvim_cmd(parsed_cmd, { output = true })
  -- if parsed_cmd.cmd ~= "!" then
  --   table.insert(lines, 1, ":" .. ctx.args)
  -- end

  local output = api.nvim_exec2(ctx.args, { output = true }).output
  for _, v in ipairs(Utils.split_lines(output)) do
    table.insert(lines, v)
  end

  if footer_sep then
    for _, v in ipairs(Utils.split_lines(footer_sep)) do
      table.insert(lines, v)
    end
  end

  View.open()

  -- TODO: refactor into standalone function
  local is_empty = api.nvim_buf_line_count(View.bufnr) == 1 and api.nvim_buf_get_offset(View.bufnr, 1) <= 1
  api.nvim_buf_set_lines(View.bufnr, is_empty and 0 or -1, -1, false, lines)
  api.nvim_win_set_cursor(View.win_id, { api.nvim_buf_line_count(View.bufnr), 0 })
  vim.opt_local.modified = false
end

api.nvim_create_user_command("Redir", function(ctx)
  if #ctx.args == 0 then
    View.open()
    return
  end
  View.generate_cmd_output(ctx)
end, {
  desc = "Redirect message output to buffer",
  nargs = "*",
  complete = "command",
})

return View
