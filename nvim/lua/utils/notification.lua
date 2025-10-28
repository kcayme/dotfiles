local M = {}

local notify = require("noice").notify
M.show_notification = function(message, level, title)
  notify(message, level, { title = title })
end

return M
