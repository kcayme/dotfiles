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

-- Prefer LSP folding if client supports it
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
