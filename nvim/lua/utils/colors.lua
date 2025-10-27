local M = {
  colors = nil,
}

M.get_base30_palette = function()
  if M.colors then
    return M.colors
  end

  local ok, base46 = pcall(require, "base46")
  if ok then
    M.colors = base46.get_theme_tb("base_30")

    return M.colors
  end

  return nil
end

M.get_base16_palette = function()
  if M.colors then
    return M.colors
  end

  local ok, base46 = pcall(require, "base46")
  if ok then
    M.colors = base46.get_theme_tb("base_16")

    return M.colors
  end

  return nil
end

return M
