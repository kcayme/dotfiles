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

return M
