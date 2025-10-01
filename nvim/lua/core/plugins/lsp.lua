return {
  {
    "mason-org/mason.nvim",
    opts = {
      -- ui = {
      --   icons = {
      --     package_installed = "✓",
      --     package_pending = "➜",
      --     package_uninstalled = "✗",
      --   },
      -- },
    },
  },
  { "neovim/nvim-lspconfig" },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      local ensure_installed = {
        "gopls",
        "jsonls",
        "yamlls",
        "lua_ls",
        "ts_ls",
        "eslint",
        "ruff",
        "ty",
        "typos_lsp",
        "prettierd",
        "cssls",
        "dockerls",
        "stylua",
      }

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        automatic_installation = true,
        -- ensure_installed = ensure_installed,
      })
    end,
  },
}
