return {
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      notify_on_error = true,
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      -- if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      --   return
      -- end
      -- return { timeout_ms = 500, lsp_fallback = true }
      --
      -- end,
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
      formatters_by_ft = {
        toml = { "pyproject-fmt" },
        lua = { "stylua" },
        python = { "ruff", "isort", "docformatter", "autopep8", stop_after_first = false },
        go = { "goimports", "gofmt", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", stop_after_first = true },
        -- json = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", stop_after_first = true },
        sql = { "sql_formatter", stop_after_first = true },
      },
    },
  },
}
