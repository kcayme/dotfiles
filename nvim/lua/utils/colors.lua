local M = {
  colors = nil,
}

M.get_base30_palette = function()
  if M.colors then
    return M.colors
  end

  local ok, bearded = pcall(require, "bearded-arc")
  if ok then
    M.colors = bearded.palette()
    return M.colors
  end

  return nil
end

return M
