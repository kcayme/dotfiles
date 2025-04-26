return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
      "folke/noice.nvim",
    },
    config = function()
      local servers = {
        -- clangd = {},
        gopls = {},
        cssmodules_ls = {
          filetypes = { "css" },
        },
        jsonls = {
          filetypes = { "json", "jsonc" },
        },
        yamlls = {
          filetypes = { "yaml", "yml" },
        },
        -- pyright = {},
        -- rust_analyzer = {},
        lua_ls = {
          -- cmd = {...},
          -- filetypes { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                -- Tells lua_ls where to find all the Lua files that you have loaded
                -- for your neovim configuration.
                library = {
                  "${3rd}/luv/library",
                  unpack(vim.api.nvim_get_runtime_file("", true)),
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
      }

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format lua code
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        -- require("cmp_nvim_lsp").default_capabilities(capabilities),
        require("blink.cmp").get_lsp_capabilities(capabilities)
      )
      require("mason-lspconfig").setup({
        automatic_installation = true,
        ensure_installed = {
          "ts_ls",
          "gopls",
          "jsonls",
          "lua_ls",
          -- "vacuum",
          "yamlls",
          "eslint",
          "typos_lsp",
          "cssls",
          "dockerls",
        },
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,

          -- ["vacuum"] = function()
          --   vim.filetype.add({
          --     pattern = {
          --       ["openapi.*%.ya?ml"] = "yaml.openapi",
          --       ["openapi.*%.json"] = "json.openapi",
          --       ["openapi-*%.ya?ml"] = "yaml.openapi",
          --       ["openapi-*%.json"] = "json.openapi",
          --     },
          --   })
          --   require("lspconfig").vacuum.setup({
          --     cmd = { "vacuum", "language-server" },
          --     filetypes = { "yaml.openapi", "json.openapi" },
          --     root_markser = { ".git" },
          --   })
          -- end,
        },
      })
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        -- javascript = { "eslint_d" },
        -- typescript = { "eslint_d" },
        -- javascriptreact = { "eslint_d" },
        -- typescriptreact = { "eslint_d" },
        lua = { "luacheck" },
        go = { "golangcilint" },
        python = { "pylint" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({
        -- "BufEnter",
        "BufWritePost",
        "InsertLeave",
      }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
          vim.diagnostic.config({ virtual_text = false })
        end,
      })
      --
      -- Show linters for the current buffer's file type
      vim.api.nvim_create_user_command("LintInfo", function()
        local filetype = vim.bo.filetype
        local linters = require("lint").linters_by_ft[filetype]

        if linters then
          print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
        else
          print("No linters configured for filetype: " .. filetype)
        end
      end, {})

      -- Toggle linting
      vim.keymap.set("n", "<leader>lt", function()
        -- vim.diagnostic.config({ virtual_text = false })
        -- vim.diagnostic.enable(not vim.diagnostic.is_enabled())
        lint.try_lint()
      end, { desc = "Trigger linting for current file" })
    end,
  },

  {
    "rshkarin/mason-nvim-lint",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint",
    },
    config = function()
      require("mason-nvim-lint").setup({
        -- A list of linters to automatically install if they're not already installed. Example: { "eslint_d", "revive" }
        -- This setting has no relation with the `automatic_installation` setting.
        -- Names of linters should be taken from the mason's registry.
        ---@type string[]
        ensure_installed = {
          -- "eslint_d",
          -- "luacheck",
          -- "golangci-lint",
          -- "pylint",
        },

        -- Whether linters that are set up (via nvim-lint) should be automatically installed if they're not already installed.
        -- It tries to find the specified linters in the mason's registry to proceed with installation.
        -- This setting has no relation with the `ensure_installed` setting.
        ---@type boolean
        automatic_installation = true,

        quiet_mode = false,
      })
    end,
  },
}
