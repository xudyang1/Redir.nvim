local Utils = {}

---Wrapper function of vim.split(s, opts) specifically for line split
---@param s string
---@param opts? { plain?:boolean, trimempty?:boolean } opts from vim.split
---@return string[]
function Utils.split_lines(s, opts)
  return vim.split(s, "\r?\n", opts)
end

return Utils
