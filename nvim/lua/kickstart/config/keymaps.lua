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
map("n", "<leader>[", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "<leader>]", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- ============ NAVIGATIONS ============
-- bufferline
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", {})
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", {})
map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })
map("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick Close buffer" })
map("n", "<leader>bs", "<cmd>BufferLinePick<cr>", {})
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Go to Previous Buffer" })
-- buffers
map({ "n" }, "<Leader>bb", "b#", { desc = "Go to previous buffer" })
map({ "n" }, "<Leader>|", "<cmd>vsplit<cr>", { desc = "Vertial split" })
map({ "n" }, "<Leader>x", "<cmd>close<cr>", { desc = "Vertial split" })
map({ "n" }, "<Leader><S-l>", "<C-W>L", { desc = "Move current buffer to right" })
map({ "n" }, "<Leader><S-h>", "<C-W>H", { desc = "Move current buffer to left" })
map({ "n" }, "-", "15<C-W><", { desc = "Decrease buffer width" })
map({ "n" }, "=", "15<C-W>>", { desc = "Increase buffer width" })

-- ============ MOTIONS AND EDITING ============
-- save file
map({ "n", "v" }, "<C-s>", "<cmd>w<cr>", {})

-- indent on visual and normal mode
map({ "n", "v" }, "<tab>", ">")
map({ "n", "v" }, "<s-tab>", "<")

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

-- Hop.vim bindings
local hop = require("hop")
local hop_position = require("hop.hint").HintPosition
map("n", "<Leader>hb", "<cmd>HopWordBC<CR>", { noremap = true, desc = "Hop prev words" })
map("n", "<Leader>hw", "<cmd>HopWordAC<CR>", { noremap = true, desc = "Hop next words" })
map("n", "<Leader>hj", "<cmd>HopLineStart<CR>", { noremap = true, desc = "Hop next line" })
-- map("n", "<Leader>hk", "<cmd>HopLineStartBC<CR>", { noremap = true, desc = "Hop prev lines" })
--map("n", "<Leader>hf", "<cmd>HopPattern<CR>", { noremap = false })
map({ "n", "v" }, "<Leader>he", function()
  hop.hint_words({ hint_position = hop_position.END })
end, { noremap = true })
-- visual mode (easymotion-like)
vim.api.nvim_set_keymap("v", "<Leader>hw", "<cmd>HopWordAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>hb", "<cmd>HopWordBC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>hj", "<cmd>HopLineStart<CR>", { noremap = true })

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
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word",
})
vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word",
})
vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = "Search on current file",
})

-- Comment
-- map("n", "<C-_>", "gcc", { noremap = true, desc = "Linewise comment" })
vim.api.nvim_set_keymap("n", "<C-_>", "gcc", { noremap = false, desc = "Linewise comment toggle" })
vim.api.nvim_set_keymap("v", "<C-_>", "gc", { noremap = false, desc = "Linewise comment toggle" })
