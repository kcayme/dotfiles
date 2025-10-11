local M = {}

M.get_screen_dimensions = function()
  local dimensions = {}
  dimensions.screen_width = vim.opt.columns:get()
  dimensions.screen_height = vim.opt.lines:get()
  return dimensions
end

return M
