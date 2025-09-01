local M = {}
-- Common passthrough methods
M.picker_interface_methods = {
  "lsp_implementations",
  "lsp_type_definitions",
  "lsp_symbols",
  "lsp_workspace_symbols",
  "lsp_declarations",
  "lsp_definitions",
  "lsp_references",
  "grep",
  "grep_word",
  "todo_comments",
  "diagnostics",
  "help",
  "jumps",
  "keymaps",
  "files",
  "buffers",
  "smart", -- frecency
  "global", -- fzf-lua specific
  "registers", -- clipboard
  "resume",
}

return M
