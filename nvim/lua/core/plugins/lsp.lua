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
        -- cssmodules_ls = {
        --   filetypes = { "css" },
        -- },
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
                -- library = {
                --   "${3rd}/luv/library",
                --   unpack(vim.api.nvim_get_runtime_file("", true)),
                -- },
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

      local ensure_installed = vim.tbl_keys(servers or {})
      local ensure_installed_lsp = {
        "ts_ls",
        "eslint",
        "typos_lsp",
        "cssls",
        "dockerls",
      }
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format lua code
        unpack(ensure_installed_lsp),
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
        ensure_installed = ensure_installed_lsp,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
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
        json = { "jsonlint" },
      }

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
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "folke/snacks.nvim",
        opts = {
          terminal = {},
        },
      },
    },
    event = "LspAttach",
    opts = {
      backend = "vim",
      picker = {
        "snacks",
        -- "buffer",
        -- opts = {
        --   hotkeys = true,
        --   position = "cursor",
        --   auto_preview = true,
        -- },
      },
    },
  },
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    config = function()
      require("aerial").setup({
        -- This can be a filetype map (see :help aerial-filetype-map)
        backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

        layout = {
          default_direction = "right",
          placement = "edge",
          -- These control the width of the aerial window.
          -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a list of mixed types.
          -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
          max_width = { 40, 0.2 },
          min_width = 45,
        },
        highlight_on_hover = true,
        autojump = true,
        show_guides = true,
        float = {
          relative = "editor",
        },
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          -- vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
          -- vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
          vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>")
        end,
      })
    end,
  },
  {
    "oribarilan/lensline.nvim",
    -- tag = "1.0.0",
    tag = "1.1.0",
    event = "LspAttach",
    config = function()
      require("lensline").setup({
        providers = { -- Array format: order determines display sequence
          -- {
          --   name = "references",
          --   enabled = true, -- enable references provider
          --   quiet_lsp = true, -- suppress noisy LSP log messages (e.g., Pyright reference spam)
          -- },
          {
            name = "last_author",
            enabled = true, -- enabled by default with caching optimization
            cache_max_files = 50, -- maximum number of files to cache blame data for (default: 50)
          },

          -- built-in providers that are diabled by default:
          {
            name = "diagnostics",
            enabled = true, -- disabled by default - enable explicitly to use
            min_level = "WARN", -- only show WARN and ERROR by default (HINT, INFO, WARN, ERROR)
          },
          {
            name = "complexity",
            enabled = false, -- disabled by default - enable explicitly to use
            min_level = "L", -- only show L (Large) and XL (Extra Large) complexity by default
          },

          -- custom providers
          {
            name = "references_with_warning",
            enabled = true,
            event = { "LspAttach", "BufWritePost" },
            handler = function(bufnr, func_info, provider_config, callback)
              local utils = require("lensline.utils")

              utils.get_lsp_references(bufnr, func_info, function(references)
                if references then
                  local count = #references
                  local icon, text

                  if count == 0 then
                    icon = utils.if_nerdfont_else("⚠️ ", "WARN ")
                    text = icon .. "No references"
                  else
                    icon = utils.if_nerdfont_else("󰌹 ", "")
                    local suffix = utils.if_nerdfont_else("", " refs")
                    text = icon .. count .. suffix
                  end

                  callback({ line = func_info.line, text = text })
                else
                  callback(nil)
                end
              end)
            end,
          },
          -- {
          --   name = "function_length",
          --   enabled = true,
          --   event = { "BufWritePost", "TextChanged" },
          --   handler = function(bufnr, func_info, provider_config, callback)
          --     local utils = require("lensline.utils")
          --     local function_lines = utils.get_function_lines(bufnr, func_info)
          --     local func_line_count = math.max(0, #function_lines - 1) -- Subtract 1 for signature
          --     local total_lines = vim.api.nvim_buf_line_count(bufnr)
          --
          --     -- Show line count for all functions
          --     callback({
          --       line = func_info.line,
          --       text = string.format("(%d/%d lines)", func_line_count, total_lines),
          --     })
          --   end,
          -- },
        },
        render = "focused", -- or "all" for showing lenses in all functions
        style = {
          placement = "inline",
          prefix = "",
          separator = " • ", -- separator between all lens attributes
          highlight = "Comment", -- highlight group for lens text
          -- prefix = "┃ ", -- prefix before lens content
          use_nerdfont = true, -- enable nerd font icons in built-in providers
        },
        limits = {
          exclude = {
            -- see config.lua for extensive list of default patterns
          },
          exclude_gitignored = true, -- respect .gitignore by not processing ignored files
          max_lines = 1000, -- process only first N lines of large files
          max_lenses = 70, -- skip rendering if too many lenses generated
        },
        debounce_ms = 300, -- unified debounce delay for all providers
        debug_mode = false, -- enable debug output for development, see CONTRIBUTE.md
      })
    end,
  },
}
