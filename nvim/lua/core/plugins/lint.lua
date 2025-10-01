return {
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
        -- python = { "pylint" },
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
      "mason-org/mason.nvim",
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
