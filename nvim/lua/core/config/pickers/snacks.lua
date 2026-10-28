local picker = require("snacks").picker

local M = {}

M.files = picker.files
M.grep = picker.grep
M.grep_word = picker.grep_word
M.buffers = picker.buffers
M.keymaps = picker.keymaps
M.global = picker.lsp_symbols
M.diagnostics = picker.diagnostics
M.help = picker.help
M.jumps = picker.jumps
M.lsp_implementations = picker.lsp_implementations
M.lsp_type_definitions = picker.lsp_type_definitions
M.lsp_symbols = picker.lsp_symbols
M.lsp_workspace_symbols = picker.lsp_workspace_symbols
M.lsp_declarations = picker.lsp_declarations
M.lsp_definitions = picker.lsp_definitions
M.lsp_references = picker.lsp_references
M.todo_comments = picker.todo_comments
M.registers = picker.registers
M.resume = picker.resume
M.undo = picker.undo
M.commands = picker.commands

---@type snacks.picker.Config
M.line_source = {
  title = ": go to line",
  live = true,
  format = "file",
  finder = function(_, ctx)
    local buf = ctx.filter.current_buf
    local count = vim.api.nvim_buf_line_count(buf)
    local line, col = ctx.filter.search:match("^(%d+):?(%d*)$")
    line = math.min(tonumber(line) or vim.api.nvim_win_get_cursor(ctx.filter.current_win)[1], count)
    col = math.max((tonumber(col) or 1) - 1, 0)
    return {
      {
        text = line .. ":" .. col,
        buf = buf,
        file = vim.api.nvim_buf_get_name(buf),
        pos = { line, col },
        line = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1],
      },
    }
  end,
}

-- custom sources the unified picker can name with `backend = "snacks"` (other names fall through to snacks' own)
M.sources = { line = M.line_source }

return M
