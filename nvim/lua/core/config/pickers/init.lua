local notify = require("utils.notification").show_notification

local backends = {}

local ok_fff, fff = pcall(require, "core.config.pickers.fff")
if ok_fff then
  backends.fff = fff
end

local ok_snacks, snacks = pcall(require, "core.config.pickers.snacks")
if ok_snacks then
  backends.snacks = snacks
else
  print(snacks)
end

local ok_fzf, fzf = pcall(require, "core.config.pickers.fzf")
if ok_fzf then
  backends.fzf = fzf
end

notify("[Pickers]: " .. table.concat(vim.tbl_keys(backends), ", "))

local Picker = {
  fallback = "snacks", -- fallback
}

local function get_backend(opts)
  local name = opts and opts.backend or Picker.fallback
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
