local M = {}

local ok, noice = pcall(require, "noice")

local notify = ok and noice.notify or vim.notify
M.show_notification = function(message, level, opts)
  opts = opts or {}

  local defaults = {
    timeout = opts.timeout or 2000,
  }

  opts = vim.tbl_deep_extend("force", defaults, opts)

  notify(message, level, opts)
end

return M
