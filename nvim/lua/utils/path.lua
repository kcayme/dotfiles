local M = {}

M.shorten_path = function(path)
  local result = vim.fn.fnamemodify(path, ":.")
  return result
end

return M
