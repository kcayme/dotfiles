local M = {}
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

-- custom command to toggle diagnostic virtual line when jumping to next diagnostic
M.jumpWithVirtLineDiags = function(jumpCount)
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

return M
