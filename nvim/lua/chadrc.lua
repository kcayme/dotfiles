-- configs for base46.lua
local M = {}

M.base46 = {
  theme = "bearded-arc", -- default theme
  hl_override = {
    DiagnosticUnderlineError = { sp = "red", undercurl = true },
    DiagnosticUnderlineWarn = { sp = "yellow", undercurl = true },
    DiagnosticUnderlineInfo = { sp = "blue", undercurl = true },
    DiagnosticUnderlineHint = { sp = "purple", undercurl = true },
    BlinkCmpGhostText = { fg = "#4e5665" },
  },
  hl_add = {
    DiagnosticUnderlineError = { sp = "red", undercurl = true },
    DiagnosticUnderlineWarn = { sp = "yellow", undercurl = true },
    DiagnosticUnderlineInfo = { sp = "blue", undercurl = true },
    DiagnosticUnderlineHint = { sp = "purple", undercurl = true },
    BlinkCmpGhostText = { fg = "#4e5665" },
  },
}

M.ui = {
  tabufline = {
    enabled = false,
  },
  statusline = {
    enabled = false,
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "block",
    lualine = true,
  },
  colorify = { enabled = false },
  lsp = { signature = true },
}
return M
