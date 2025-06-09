local map = vim.keymap.set

map("n", "<Esc>", function()
  -- clear highlights
  vim.cmd("nohlsearch")
  -- clear notifications
  require("notify").dismiss()
end, { desc = "Clear notifs and highlights" })

-- ============ DIAGNOSTICS ============
---@param jumpCount number
local function jumpWithVirtLineDiags(jumpCount)
  pcall(vim.api.nvim_del_augroup_by_name, "jumpWithVirtLineDiags") -- prevent autocmd for repeated jumps

  vim.diagnostic.jump({ count = jumpCount })

  local initialVirtTextConf = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { current_line = true },
  })

  vim.defer_fn(function() -- deferred to not trigger by jump itself
    vim.api.nvim_create_autocmd("CursorMoved", {
      desc = "User(once): Reset diagnostics virtual lines",
      once = true,
      group = vim.api.nvim_create_augroup("jumpWithVirtLineDiags", {}),
      callback = function()
        vim.diagnostic.config({ virtual_lines = false, virtual_text = initialVirtTextConf })
      end,
    })
  end, 1)
end

map("n", "<leader>]", function()
  jumpWithVirtLineDiags(1)
end, { desc = "󰒕 Next diagnostic" })
map("n", "<leader>[", function()
  jumpWithVirtLineDiags(-1)
end, { desc = "󰒕 Prev diagnostic" })
-- map("n", "<leader>[", function()
--   vim.diagnostic.jump({ count = 1, float = true })
-- end, { desc = "Go to previous [D]iagnostic message" })
--
-- map("n", "<leader>]", function()
--   vim.diagnostic.jump({ count = -1, float = true })
-- end, { desc = "Go to next [D]iagnostic message" })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- ============ NAVIGATIONS ============
map({ "n", "v" }, "gh", "^", { desc = "Go to start of line" })
map({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up with scrolloff" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with scrolloff" })
map("n", "j", function()
  local api = require("nvim-tree.api")
  if api.tree.is_tree_buf() then
    return "j"
  end
  return "jzz"
end, { silent = true, expr = true, noremap = true })

map("n", "k", function()
  local api = require("nvim-tree.api")
  if api.tree.is_tree_buf() then
    return "k"
  end
  return "kzz"
end, { silent = true, expr = true, noremap = true })

-- buffers and windows
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Go to Previous Buffer" })
map({ "n" }, "<Leader>X", "<cmd>close<cr>", { desc = "Close window" })
map({ "n" }, "<Leader>|", "<cmd>vsplit<cr>", { desc = "Vertical window split" })
-- map({ "n" }, "<Leader><S-l>", "<C-W>L", { desc = "Move current buffer to right" })
-- map({ "n" }, "<Leader><S-h>", "<C-W>H", { desc = "Move current buffer to left" })
map({ "n" }, "<Leader><tab>", "<cmd>tabnext<cr>", { desc = "Go to next tab" })
map({ "n" }, "<Leader>tc", "<cmd>tabclose<cr>", { desc = "[T]ab [C]lose" })
map({ "n" }, "-", "15<C-W><", { desc = "Decrease buffer width" })
map({ "n" }, "=", "15<C-W>>", { desc = "Increase buffer width" })
map({ "n" }, "+", "5<C-W>+", { desc = "Increase buffer height" })
map({ "n" }, "_", "5<C-W>-", { desc = "Decrease buffer height" })

-- ============ MOTIONS AND EDITING ============
-- save file
map({ "n", "v" }, "<C-s>", "<cmd>w<cr>", {})

-- keep previously yanked word
map({ "v" }, "p", '"_dP', { noremap = false })

-- indent on visual and normal mode
map({ "n" }, "<tab>", ">>")
map({ "n" }, "<s-tab>", "<<")
map({ "v" }, "<tab>", ">gv", { noremap = true })
map({ "v" }, "<s-tab>", "<gv", { noremap = true })

-- fold
map({ "n" }, "zx", "za", { desc = "Toggle fold under cursor" })
map({ "n" }, "zcf", "zC", { desc = "Recursive fold under cursor" })
map({ "n" }, "zcu", "zo", { desc = "Recursive unfold under cursor" })
map({ "n" }, "zf", "zM", { desc = "Fold all" })
map({ "n" }, "zu", "zR", { desc = "Unfold all" })

map("i", "jj", "<Esc>", { silent = true, noremap = false })
map("n", "<C-s>", "<cmd>w<cr>", { silent = false, desc = "Save File" })

-- nvim-surround
vim.api.nvim_set_keymap("n", "<Leader>lw", "ysiw", { noremap = false, desc = "Surround [w]ord" })
vim.api.nvim_set_keymap("n", "<Leader>lW", "ysiW", { noremap = false, desc = "Surround [W]ord" })
vim.api.nvim_set_keymap("n", "<Leader>la", "ysa", { noremap = false, desc = "Surround delimited" })
vim.api.nvim_set_keymap("n", "<Leader>ll", "yss", { noremap = false, desc = "Surround line" })

-- nvim-spider
map({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
map({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
map({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })

-- -- nvim-spectre
-- map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
--   desc = "Toggle Spectre",
-- })
-- map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
--   desc = "Search current word",
-- })
-- map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
--   desc = "Search current word",
-- })
-- map("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
--   desc = "Search on current file",
-- })
