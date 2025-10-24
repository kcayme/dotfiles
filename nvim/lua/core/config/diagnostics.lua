local custom_signs = require("core.themes.signs")
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = custom_signs.error,
      [vim.diagnostic.severity.WARN] = custom_signs.warn,
      [vim.diagnostic.severity.INFO] = custom_signs.info,
      [vim.diagnostic.severity.HINT] = custom_signs.hint,
    },
  },
})
