local Config = require("redir.config")
local LayoutStyle = require("redir.constants").LayoutStyle
local api = vim.api

---@class RedirView
---@field win_id integer
---@field bufnr integer
---@field current_layout_style LayoutStyle
---@field layout_config RedirLayoutConfig
local View = {
  win_id = -1,
  bufnr = -1,
}

function View.setup()
  local layout_config = {}
  local options = Config.options

  for k, v in pairs(options.layout_config) do
    layout_config[k] = v
  end

  View.layout_config = layout_config
  View.current_layout_style = options.layout_style
end

function View.is_win_open()
  return api.nvim_win_is_valid(View.win_id) and api.nvim_win_get_buf(View.win_id) == View.bufnr
end

---Get View win_id if valid, or the current win_id, or use the fallback win_id
---@param win_id? integer fallback win_id
---@return integer
function View.get_valid_win_id(win_id)
  if not View.is_win_open() then
    View.win_id = win_id or api.nvim_get_current_win()
  end
  return View.win_id
end

function View.is_buf_valid()
  return api.nvim_buf_is_valid(View.bufnr)
end

---Get View bufnr if valid, or create a new buffer, or use the fallback bufnr
---@param bufnr? integer fallback bufnr
---@return integer
function View.get_valid_bufnr(bufnr)
  if not View.is_buf_valid() then
    View.bufnr = bufnr or api.nvim_create_buf(false, true)
  end
  return View.bufnr
end

function View.close_win()
  if View.is_win_open() then
    api.nvim_win_close(View.win_id, false)
  end
  View.win_id = -1
end

function View.open_win()
  View["open_" .. View.current_layout_style]()
end

---Set current win to Redir buffer, or focus the opening Redir win
function View.win_set_buf()
  local win_id = View.get_valid_win_id()
  local bufnr = View.get_valid_bufnr()
  api.nvim_win_set_buf(win_id, bufnr)
end

function View.open_vertical()
  if View.current_layout_style ~= LayoutStyle.vertical then
    View.close_win()
  end

  View.current_layout_style = LayoutStyle.vertical

  vim.cmd.split({ mods = { vertical = true } })
  View.win_set_buf()
end

function View.open_horizontal()
  if View.current_layout_style ~= LayoutStyle.horizontal then
    View.close_win()
  end

  View.current_layout_style = LayoutStyle.horizontal

  vim.cmd.split({ mods = { vertical = false } })
  View.win_set_buf()
end

function View.open_tab()
  if View.current_layout_style ~= LayoutStyle.tab then
    View.close_win()
  end

  View.current_layout_style = LayoutStyle.tab

  vim.cmd("tabnew")
  View.win_set_buf()
end

function View.open_float()
  local function get_size(max_val, val)
    return val > 1 and math.min(max_val, val) or math.floor(max_val * val)
  end

  local float = View.layout_config.float

  local width = get_size(vim.o.columns, float.width)
  local height = get_size(vim.o.lines, float.height)

  local top = math.floor(((vim.o.lines - height) / 2))
  local left = math.floor(((vim.o.columns - width) / 2))

  -- local border = float.border or "none"
  View.win_opts = {
    relative = "editor",
    style = "minimal",
    title = float.title,
    title_pos = float.title_pos,
    width = width,
    height = height,
    row = top,
    col = left,
    border = float.border,
  }

  View.win_id = api.nvim_open_win(View.get_valid_bufnr(), true, View.win_opts)
end

-- TODO: refactor into cmd logic
function View.generate_cmd_output(ctx)
  local parsed_cmd = api.nvim_parse_cmd(ctx.args, {})
  local output = api.nvim_cmd(parsed_cmd, { output = true })
  local lines = vim.split(output, "\n", { plain = true })

  if parsed_cmd.cmd ~= "!" then
    table.insert(lines, 1, ":" .. ctx.args)
  end

  View.open_win()

  -- TODO: refactor into standalone function
  local is_empty = api.nvim_buf_line_count(View.bufnr) == 1 and api.nvim_buf_get_offset(View.bufnr, 1) <= 1

  -- CHECK string or function: string
  -- TODO: when separator include "\n", api.nvim_buf_set_lines results in error
  -- add addtional convertion to split separator and then insert into lines
  -- local format = Config.options.output_format
  -- if format.footer then
  -- end
  -- if format.footer then
  -- end
  -- table.insert(lines, 1, header(parsed_cmd))

  api.nvim_buf_set_lines(View.bufnr, is_empty and 0 or -1, -1, false, lines)
  api.nvim_win_set_cursor(View.win_id, { api.nvim_buf_line_count(View.bufnr), 0 })
  vim.opt_local.modified = false
end

api.nvim_create_user_command("Redir", function(ctx)
  View.generate_cmd_output(ctx)
end, {
  desc = "Redirect message output to buffer",
  nargs = "+",
  -- @bug: `:Redir !shellcommand` results in hanging, ^C kills the completion
  complete = "command",
})

vim.keymap.set("n", "<Leader>ms", View.open_win, { desc = "Open Message" })

return View
