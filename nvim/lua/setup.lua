-- setup options before lazy loading
if vim.g.vscode then
  require("code.config.options")
else
  require("kickstart.config.options")
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
    -- { import = "kickstart.themes.tokyonight" },
    {
      import = "kickstart.themes.base46",
      cond = function()
        return not vim.g.vscode
      end,
    },
    {
      import = "kickstart.plugins",
      cond = function()
        return not vim.g.vscode
      end,
    },
    {
      import = "code.plugins46",
      cond = function()
        return vim.g.vscode
      end,
    },
  },
  checker = { enabled = true },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})

-- Load appropriate plugins, settings, and keymaps
if vim.g.vscode then
  require("code.config.keymaps")
  require("code.config.autocmds")
  print("vscode config loaded")
else
  require("kickstart.config.options")
  require("kickstart.config.autocmds")
  require("kickstart.config.highlights")
  require("kickstart.config.keymaps")
  print("default config loaded")
end
