return {
  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "folke/trouble.nvim",
    },
    config = function()
      require("go").setup({
        trouble = true,
        -- verbose = false,
        -- diagnostic = false,
        -- diagnostic = { -- set diagnostic to false to disable vim.diagnostic.config setup,
        -- true: default nvim setup
        -- hdlr = true, -- hook lsp diag handler and send diag to quickfix
        -- underline = true,
        -- virtual_text = { spacing = 2, prefix = "" }, -- virtual text setup
        -- signs = { "", "", "", "" }, -- set to true to use default signs, an array of 4 to specify custom signs
        -- update_in_insert = false,
        -- },
      })
      local map = vim.keymap.set
      map("n", "<leader>got", "<cmd>GoTestFunc<cr>", {})
    end,
    -- event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },
}
