local picker = require("fff")

local fff = {}

-- local picker_interface_methods = require("core.config.backends.common")
--
-- for _, method in ipairs(picker_interface_methods) do
--   fff[method] = function(opts)
--     fff.library[method](opts)
--   end
-- end

-- override for fzf-lua-specific methods
fff.files = function(opts)
  picker.find_files(opts)
end

fff.smart = function(opts)
  picker.find_files(opts)
end

return fff
