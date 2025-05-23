-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

vim.o.foldenable = true
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
vim.o.foldmethod = "indent"
vim.o.foldlevelstart = 999
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.opt.scrolloff = 999
--vim.o.virtualedit = true

-- Make line numbers default
vim.wo.number = true
-- Enable relativenumber
vim.wo.relativenumber = true
vim.o.smartcase = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
--vim.o.breakindent = true

-- Save undo history
--vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
--vim.o.termguicolors = true
