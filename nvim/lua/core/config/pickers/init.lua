local notify = require("utils.notification").notify

local function get_backend(opts)
  local name = opts and opts.backend

  if name ~= "snacks" and name ~= "fff" then
    notify("[PICKER] Unsupported backend: " .. tostring(name), vim.log.levels.WARN)
    return nil
  end

  -- local backend = backends[name]

  local ok_fff, backend = pcall(require, "core.config.pickers." .. name)
  if not ok_fff then
    notify("[PICKER] Failed to load picker backend: " .. tostring(name), vim.log.levels.ERROR)
    return nil
  end

  -- local ok_snacks, snacks = pcall(require, "core.config.pickers.snacks")
  -- if ok_snacks then
  --   backends.snacks = snacks.picker
  -- end

  -- notify("[PICKER]: " .. table.concat(vim.tbl_keys(backends), ", "))

  return backend

  -- if not backend then
  -- end

  -- return {
  --   name = name,
  -- }
end

local Picker = {}

function Picker.smart(opts)
  local backend = get_backend(opts)
  backend.smart(opts)
end

function Picker.files(opts)
  local backend = get_backend(opts)
  backend.files(opts)
end

function Picker.grep(opts)
  local backend = get_backend(opts)
  backend.grep(opts)
end

function Picker.buffers(opts)
  local backend = get_backend(opts)
  backend.buffers(opts)
end

function Picker.keymaps(opts)
  local backend = get_backend(opts)
  backend.keymaps(opts)
end

-- INFO: unused!
function Picker.global(opts)
  local backend = get_backend(opts)
  backend.global(opts)
end

function Picker.diagnostics(opts)
  local backend = get_backend(opts)
  backend.diagnostics(opts)
end

function Picker.help(opts)
  local backend = get_backend(opts)
  backend.help(opts)
end

function Picker.jumps(opts)
  local backend = get_backend(opts)
  backend.jumps(opts)
end

function Picker.lsp_implementations(opts)
  local backend = get_backend(opts)
  backend.lsp_implementations(opts)
end

function Picker.lsp_type_definitions(opts)
  local backend = get_backend(opts)
  backend.lsp_type_definitions(opts)
end

function Picker.lsp_symbols(opts)
  local backend = get_backend(opts)
  backend.lsp_symbols(opts)
end

function Picker.lsp_workspace_symbols(opts)
  local backend = get_backend(opts)
  backend.lsp_workspace_symbols(opts)
end

function Picker.lsp_declarations(opts)
  local backend = get_backend(opts)
  backend.lsp_declarations(opts)
end

function Picker.lsp_definitions(opts)
  local backend = get_backend(opts)
  backend.lsp_definitions(opts)
end

function Picker.lsp_references(opts)
  local backend = get_backend(opts)
  backend.lsp_references(opts)
end

function Picker.grep_word(opts)
  local backend = get_backend(opts)
  backend.grep_word(opts)
end

function Picker.todo_comments(opts)
  local backend = get_backend(opts)
  backend.todo_comments(opts)
end

function Picker.registers(opts)
  local backend = get_backend(opts)
  backend.registers(opts)
end

function Picker.resume(opts)
  local backend = get_backend(opts)
  backend.resume(opts)
end

function Picker.undo(opts)
  local backend = get_backend(opts)
  backend.undo(opts)
end

function Picker.commands(opts)
  local backend = get_backend(opts)
  backend.commands(opts)
end

return Picker
