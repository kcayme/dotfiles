local backends = {
  fff = require("core.config.backends.fff"),
  snacks = require("core.config.backends.snacks"),
  fzf = require("core.config.backends.fzf"),
}

local Picker = {
  default_backend = "snacks", -- fallback
}

local function get_backend(opts)
  local name = opts and opts.backend or Picker.default_backend
  local backend = backends[name]
  assert(backend, "Unsupported backend: " .. tostring(name))
  return backend
end

-- Use metatable to forward undefined methods
setmetatable(Picker, {
  __index = function(_, method_name)
    return function(opts)
      local backend = get_backend(opts)
      local method = backend[method_name]
      assert(method, "Method not found in backend: " .. method_name)
      return method(opts)
    end
  end,
})

return Picker
