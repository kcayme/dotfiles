-- setup options before lazy loading
if vim.g.vscode then
  require("code.config.options")
else
  require("core.config.options")
  vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- { import = "core.themes.tokyonight" },
    {
      import = "core.themes.base46",
      cond = function()
        return not vim.g.vscode
      end,
    },
    {
      import = "core.plugins",
      cond = function()
        return not vim.g.vscode
      end,
    },
    {
      import = "code.plugins",
      cond = function()
        return vim.g.vscode
      end,
    },
  },
  checker = { enabled = true },
})

local profile = ""

-- Load appropriate plugins, settings, and keymaps
if vim.g.vscode then
  require("code.config.keymaps")
  require("code.config.autocmds")
  profile = "vscode"
else
  require("core.config.diagnostics")
  require("core.config.autocmds")
  require("core.config.commands")
  require("core.config.highlights")
  require("core.config.keymaps")
  require("core.config.lsp")
  profile = "default"
end

local notify = require("utils.notification").show_notification
notify("Config loaded: " .. profile, vim.log.levels.INFO, { timeout = 2000 })
