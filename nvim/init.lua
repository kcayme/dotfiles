-- Load appropriate plugins, settings, and keymaps
if vim.g.vscode then
  require("code.init")
  print("vscode config loaded")
else
  require("kickstart.init")
  print("default config loaded")
end
