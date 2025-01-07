local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- setup options and autocmds
require("code.config.options")
require("code.config.autocmds")

-- setup plugins
require("lazy").setup({
  { import = "code.plugins.surround" },
  { import = "code.plugins.hop" },
  { import = "code.plugins.neoscroll" },
  { import = "code.plugins.spider" },

  defaults = {
    lazy = false,
    -- version = false, -- always use the latest git commit
    version = "*", -- try installing the latest stable version for plugins that support semver
  },
  --install = { colorscheme = { "nightfly" } },
  checker = { enabled = true }, -- automatically check for plugin updates
})

-- setup keymaps
require("code.config.keymaps")
