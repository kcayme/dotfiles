-- Single entrypoint for all plugins in this directory.
if vim.g.vscode then
  return {}
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

local specs = {}
for _, name in ipairs(modules) do
  local ok, spec = pcall(require, "core.plugins." .. name)
  if ok then
    table.insert(specs, spec)
  else
    -- A missing/broken module shouldn't take down the whole config.
    vim.schedule(function()
      vim.notify("plugin module '" .. name .. "' failed to load: " .. tostring(spec), vim.log.levels.WARN)
    end)
  end
end

return specs
