return {
  {
    "williamboman/mason.nvim",
    opts = {
      -- ui = {
      --   icons = {
      --     package_installed = "✓",
      --     package_pending = "➜",
      --     package_uninstalled = "✗",
      --   },
      -- },
    },
    -- config = function()
    --   require("mason").setup()
    -- end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local ensure_installed = {
        "gopls",
        "jsonls",
        "yamlls",
        "lua_ls",
        "ts_ls",
        "eslint",
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
