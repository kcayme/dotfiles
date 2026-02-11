return {
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
        "vue_ls",
        "ts_ls",
        "eslint",
        "ruff",
        "basedpyright",
        "typos_lsp",
        "postgres_lsp",
        "prettierd",
        "cssls",
        "dockerls",
        "stylua",
        "tailwindcss",
      }

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        automatic_installation = true,
        automatic_enable = {
          exclude = {
            "basedpyright",
          },
        },
        -- ensure_installed = ensure_installed,
      })
    end,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
      require("tiny-inline-diagnostic").setup({
        options = {
          multilines = {
            enabled = true,
          },
          show_source = {
            enabled = true,
          },
          add_messages = {
            display_count = true,
          },
        },
      })
      vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
    end,
  },
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    event = "LspAttach",
    opts = {
      backend = "vim",
      picker = {
        "snacks",
      },
      sort = function(a, b)
        -- Prioritize quickfix actions, then refactoring, then everything else
        local function get_priority(kind)
          if string.match(kind or "", "^quickfix") then
            return 1
          end
          if string.match(kind or "", "^refactor") then
            return 2
          end
          return 3
        end

        local a_priority = get_priority(a.action.kind)
        local b_priority = get_priority(b.action.kind)

        return a_priority < b_priority
      end,
    },
  },
  { "microsoft/python-type-stubs" },
}
