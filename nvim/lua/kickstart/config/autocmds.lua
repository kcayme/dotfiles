vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  desc = "Change the cursor in the tree for the current focused buffer",
  group = vim.api.nvim_create_augroup("nvim-tree-cursor-focus", { clear = true }),
  callback = function()
    local api = require("nvim-tree.api")
    api.tree.find_file({ open = false, focus = false })
  end,
})
