local Utils = {}

---Split content into array of strings by line breaks
---@param s string String to split
---@param opts? vim.gsplit.Opts Keyword arguments
---@return string[]
function Utils.split_lines(s, opts)
  return vim.split(s, "\r?\n", opts)
end

---Return a valid size for window width or height
---@param max_val integer Maximum size value
---@param val number Desired size or proportion
---@return integer? When val > 1, return floor of val; when 0 < val <=1, return proportion of max_val; return nil otherwise
function Utils.get_size(max_val, val)
  if val <= 0 then
    vim.notify("Input size should be greater than zero, received " .. tostring(val))
    return
  end
  return val > 1 and math.floor(math.min(max_val, val)) or math.floor(max_val * val)
end

return Utils
