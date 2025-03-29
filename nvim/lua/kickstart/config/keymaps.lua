-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

local map = vim.keymap.set

map("n", "<Esc>", function()
  -- clear highlights
  vim.cmd("nohlsearch")
  -- clear notifications
  require("notify").dismiss()
end, { desc = "Clear notifs and highlights" })

-- ============ DIAGNOSTICS ============
-- map("n", "<leader>[", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
-- map("n", "<leader>]", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>[", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to previous [D]iagnostic message" })

map("n", "<leader>]", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to next [D]iagnostic message" })

map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- ============ NAVIGATIONS ============
map("n", "gh", "^", { desc = "Go to start of line" })
map("n", "gl", "$", { desc = "Go to end of line" })

-- buffers
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Go to Previous Buffer" })
map({ "n" }, "<Leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map({ "n" }, "<Leader>x", "<cmd>close<cr>", { desc = "Vertical split" })
-- map({ "n" }, "<Leader><S-l>", "<C-W>L", { desc = "Move current buffer to right" })
-- map({ "n" }, "<Leader><S-h>", "<C-W>H", { desc = "Move current buffer to left" })
map({ "n" }, "<Leader><tab>", "<cmd>tabnext<cr>", { desc = "Go to next tab" })
map({ "n" }, "-", "15<C-W><", { desc = "Decrease buffer width" })
map({ "n" }, "=", "15<C-W>>", { desc = "Increase buffer width" })
map({ "n" }, "+", "5<C-W>+", { desc = "Increase buffer height" })
map({ "n" }, "_", "5<C-W>-", { desc = "Decrease buffer height" })

-- ============ MOTIONS AND EDITING ============
-- save file
map({ "n", "v" }, "<C-s>", "<cmd>w<cr>", {})

-- indent on visual and normal mode
map({ "n", "v" }, "<tab>", ">>")
map({ "n", "v" }, "<s-tab>", "<<")

-- fold
map({ "n" }, "zx", "za", { desc = "Toggle fold under cursor" })
map({ "n" }, "zcf", "zC", { desc = "Recursive fold under cursor" })
map({ "n" }, "zcu", "zo", { desc = "Recursive unfold under cursor" })
map({ "n" }, "zf", "zM", { desc = "Fold all" })
map({ "n" }, "zu", "zR", { desc = "Unfold all" })

vim.api.nvim_set_keymap("n", "j", "gj", { silent = true, noremap = false })
vim.api.nvim_set_keymap("n", "k", "gk", { silent = true, noremap = false })
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { silent = true, noremap = false })
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

-- nvim-spectre
map("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre",
})
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word",
})
map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word",
})
map("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = "Search on current file",
})
