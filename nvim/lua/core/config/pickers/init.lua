local notify = require("utils.notification").notify

local backends = {}

local ok_fff, fff = pcall(require, "core.config.pickers.fff")
if ok_fff then
  backends.fff = fff
end

local ok_snacks, snacks = pcall(require, "core.config.pickers.snacks")
if ok_snacks then
  backends.snacks = snacks.picker
else
  notify("snacks unavailable", vim.log.levels.WARN)
end

notify("[Pickers]: " .. table.concat(vim.tbl_keys(backends), ", "))
local Picker = {}

local function get_backend(opts)
  local name = opts and opts.backend or "snacks"
  local backend = backends[name]

  if not backend then
    notify("[PICKER] Unsupported backend: " .. tostring(name), vim.log.levels.WARN)

    return nil
  end

  return {
    name = name,
  }
end

function Picker.smart(opts)
  local result = get_backend(opts)

  if result and result.name == "fff" then
    backends.fff.smart(opts)

    return
  end
end

function Picker.files(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.files(opts)

    return
  end
end

function Picker.grep(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.grep(opts)

    return
  end
end

function Picker.buffers(opts)
  local result = get_backend(opts)

  opts = opts or {}

  if result and result.name == "snacks" then
    opts.filter = vim.tbl_extend("force", opts.filter or {}, { cwd = true })
    backends.snacks.buffers(opts)

    return
  end
end

function Picker.keymaps(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.keymaps(opts)

    return
  end
end

function Picker.global(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.lsp_symbols(opts)

    return
  end
end

function Picker.diagnostics(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.diagnostics(opts)

    return
  end
end

function Picker.help(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.help(opts)

    return
  end
end

function Picker.jumps(opts)
  local result = get_backend(opts)

  opts = opts or {}

  if result and result.name == "snacks" then
    opts.filter = vim.tbl_extend("force", opts.filter or {}, { cwd = true })
    backends.snacks.buffers(opts)

    return
  end
end

function Picker.lsp_implementations(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.lsp_implementations(opts)

    return
  end
end

function Picker.lsp_type_definitions(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.lsp_type_definitions(opts)

    return
  end
end

function Picker.lsp_symbols(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.lsp_symbols(opts)

    return
  end
end

function Picker.lsp_workspace_symbols(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.lsp_workspace_symbols(opts)

    return
  end
end

function Picker.lsp_declarations(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.lsp_declarations(opts)

    return
  end
end

function Picker.lsp_definitions(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.lsp_definitions(opts)

    return
  end
end

function Picker.lsp_references(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.lsp_references(opts)

    return
  end
end

function Picker.grep_word(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.grep_word(opts)

    return
  end
end

function Picker.todo_comments(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.todo_comments(opts)

    return
  end
end

function Picker.registers(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.registers(opts)

    return
  end
end

function Picker.resume(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.resume(opts)

    return
  end
end

function Picker.undo(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.undo(opts)

    return
  end
end

function Picker.commands(opts)
  local result = get_backend(opts)

  if result and result.name == "snacks" then
    backends.snacks.commands(opts)

    return
  end
end

return Picker
