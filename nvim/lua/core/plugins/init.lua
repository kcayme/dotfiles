-- Single entrypoint for all plugins in this directory.
local specs = {}

if vim.g.vscode then
  return specs
end

local modules = {
  "ai",
  "aerial",
  "arrow",
  "autocompletion",
  "autopairs",
  "buffers",
  "colorizer",
  "comment",
  "conform",
  "flash",
  "fold",
  "git",
  "go",
  "hop",
  "http",
  "lazydev",
  "lint",
  "lsp",
  "lualine",
  "mini",
  "noice",
  "nvim-tree",
  "oil",
  "paste",
  "pickers",
  "previewers",
  "session",
  "sleuth",
  "spider",
  "split-join",
  "surround",
  "tmux-nav",
  "todo",
  "treesitter",
  "trouble",
  "undotree",
}

for _, name in ipairs(modules) do
  local ok, spec = pcall(require, "core.plugins." .. name)
  if ok then
    table.insert(specs, spec)
  else
    local notify = require("utils.notification").notify

    notify("plugin '" .. name .. "' failed to load: " .. tostring(spec), vim.log.levels.WARN)
  end
end

return specs
