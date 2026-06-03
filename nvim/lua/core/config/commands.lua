local notify = require("utils.notification").notify

vim.api.nvim_create_user_command("FormatToggle", function(args)
  local opts = { title = "conform.nvim" }
  local is_global = not args.bang

  if is_global then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    if vim.g.disable_autoformat then
      notify("Autoformat-on-save disabled globally", "info", opts)
    else
      notify("Autoformat-on-save enabled globally", "info", opts)
    end
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    if vim.b.disable_autoformat then
      notify("Autoformat-on-save disabled for this buffer", "info", opts)
    else
      notify("Autoformat-on-save enabled for this buffer", "info", opts)
    end
  end
end, {
  desc = "Toggle autoformat-on-save",
  bang = true,
})

-- Show linters for the current buffer's file type
vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local linters = require("lint").linters_by_ft[filetype]

  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end, {})

vim.api.nvim_create_user_command("WrapToggle", function(args)
  vim.g.disable_wrap = not vim.g.disable_wrap

  if vim.g.disable_wrap then
    vim.o.wrap = false
    notify("line wrap: disabled", "info")
  else
    vim.o.wrap = true
    notify("line wrap: enabled", "info")
  end
end, { desc = "Toggle line wrap" })
