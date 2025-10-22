local M = {
  colors = nil,
}

M.get_base30_palette = function()
  local ok, base46 = pcall(require, "base46")
  if ok then
    return base46.get_theme_tb("base_30")
  end

  return nil
end

return M
