-- INFO: disabled for now since not currently working with go projects
return {
  -- {
  --   "ray-x/go.nvim",
  --   dependencies = { -- optional packages
  --     "ray-x/guihua.lua",
  --     "neovim/nvim-lspconfig",
  --     "nvim-treesitter/nvim-treesitter",
  --     "folke/trouble.nvim",
  --   },
  --   config = function()
  --     require("go").setup({
  --       lsp_semantic
  --       lsp_cfg = true,
  --       trouble = false,
  --       -- verbose = false,
  --       -- diagnostic = false,
  --       -- diagnostic = { -- set diagnostic to false to disable vim.diagnostic.config setup,
  --       -- true: default nvim setup
  --       -- hdlr = true, -- hook lsp diag handler and send diag to quickfix
  --       -- underline = true,
  --       -- virtual_text = { spacing = 2, prefix = "" }, -- virtual text setup
  --       -- signs = { "", "", "", "" }, -- set to true to use default signs, an array of 4 to specify custom signs
  --       -- update_in_insert = false,
  --       -- },
  --     })
  --     -- local map = vim.keymap.set
  --     -- map("n", "<leader>got", "<cmd>GoTestFunc<cr>", {})
  --
  --     local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       pattern = "*.go",
  --       callback = function()
  --         require("go.format").goimports()
  --       end,
  --       group = format_sync_grp,
  --     })
  --   end,
  --   event = { "CmdlineEnter" },
  --   ft = { "go", "gomod" },
  --   build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  -- },
  {
    "fatih/vim-go",
    ft = "go",
    build = ":GoInstallBinaries", -- Installs necessary Go binaries
    config = function()
      -- Optional: configure vim-go to explicitly use gopls
      -- LazyVim already handles gopls via its 'go' extra, but this ensures compatibility
      -- vim.g.go_def_mode = "gopls"
      -- vim.g.go_info_mode = "gopls"
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_function_parameters = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_generate_tags = 1
      vim.g.go_highlight_format_strings = 1
      vim.g.go_highlight_variable_declarations = 1
      vim.g.go_highlight_variable_assignments = 1
      vim.g.go_highlight_array_whitespace_error = 1
      vim.g.go_highlight_chan_whitespace_error = 1
      vim.g.go_highlight_space_tab_error = 1
    end,
  },
}
