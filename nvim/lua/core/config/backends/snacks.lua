local picker = require("snacks").picker

local snacks = {}

local picker_interface_methods = require("core.config.backends.common")

for _, method in ipairs(picker_interface_methods) do
  snacks[method] = function(opts)
    picker[method](opts)
  end
end

-- Custom logic
snacks.buffers = function(opts)
  opts = opts or {}
  opts.filter = vim.tbl_extend("force", opts.filter or {}, { cwd = true })
  picker.buffers(opts)
end

snacks.jumps = function(opts)
  opts = opts or {}
  opts.filter = vim.tbl_extend("force", opts.filter or {}, { cwd = true })
  picker.jumps(opts)
end

return snacks
