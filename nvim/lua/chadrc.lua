-- configs for base46.lua
local M = {}

M.base46 = {
  theme = "bearded-arc", -- default theme
}

M.ui = {
  tabufline = {
    enabled = false,
  },
  statusline = {
    enabled = true,
    theme = "default", -- default/vscode/vscode_colored/minimal
    -- default/round/block/arrow separators work only for default statusline theme
    -- round and block will work for minimal theme only
    separator_style = "block",
    lualine = true,
  },
  -- telescope = { style = "bordered" },
}
return M
