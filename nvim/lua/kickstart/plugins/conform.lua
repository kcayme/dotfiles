return {
  { -- Autoformat
    "stevearc/conform.nvim",
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black", stop_after_first = true },
        go = { "goimports", "gofmt", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", stop_after_first = true },
        yaml = { "prettierd", stop_after_first = true },
        sql = { "sql_formatter", stop_after_first = true },
      },
    },
  },
}
