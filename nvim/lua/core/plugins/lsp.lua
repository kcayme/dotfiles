return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
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
      -- local servers = {
      --   -- clangd = {},
      --   gopls = {},
      --   -- cssmodules_ls = {
      --   --   filetypes = { "css" },
      --   -- },
      --   jsonls = {
      --     filetypes = { "json", "jsonc" },
      --   },
      --   yamlls = {
      --     filetypes = { "yaml", "yml" },
      --   },
      --   -- pyright = {},
      --   -- rust_analyzer = {},
      --   lua_ls = {
      --     -- cmd = {...},
      --     -- filetypes { ...},
      --     -- capabilities = {},
      --     settings = {
      --       Lua = {
      --         runtime = { version = "LuaJIT" },
      --         workspace = {
      --           checkThirdParty = false,
      --           -- Tells lua_ls where to find all the Lua files that you have loaded
      --           -- for your neovim configuration.
      --           -- library = {
      --           --   "${3rd}/luv/library",
      --           --   unpack(vim.api.nvim_get_runtime_file("", true)),
      --           -- },
      --         },
      --         completion = {
      --           callSnippet = "Replace",
      --         },
      --         -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      --         diagnostics = { disable = { "missing-fields" } },
      --       },
      --     },
      --   },
      -- }

      -- local ensure_installed = vim.tbl_keys(servers or {})

      local ensure_installed = {
        "gopls",
        "jsonls",
        "yamlls",
        "lua_ls",
        "ts_ls",
        "eslint",
        "typos_lsp",
        "cssls",
        "dockerls",
      }
      -- vim.list_extend(ensure_installed, {
      --   "stylua", -- Used to format lua code
      --   unpack(ensure_installed_lsp),
      -- })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = ensure_installed,
        --   handlers = {
        --     function(server_name)
        --       local server = servers[server_name] or {}
        --       -- This handles overriding only values explicitly passed
        --       -- by the server configuration above. Useful when disabling
        --       -- certain features of an LSP (for example, turning off formatting for tsserver)
        --       server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        --       require("lspconfig")[server_name].setup(server)
        --     end,
        --   },
      })
    end,
  },
}
