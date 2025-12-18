return {
  -- swagger preview
  {
    "vinnymeller/swagger-preview.nvim",
    cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
    build = "npm i",
    config = function()
      require("swagger-preview").setup({
        -- The port to run the preview server on
        port = 9000,
        -- The host to run the preview server on
        host = "localhost",
      })
    end,
  },
  -- markdown preview
  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      -- You can choose one of the following pickers
      "folke/snacks.nvim",
    },
  },
  -- {
  --   "MeanderingProgrammer/render-markdown.nvim",
  --   dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  --   ---@module 'render-markdown'
  --   ---@type render.md.UserConfig
  --   opts = {},
  --   config = function()
  --     require("render-markdown").setup({
  --       completions = { lsp = { enabled = true } },
  --     })
  --   end,
  -- },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    keys = {
      { "<leader>md", "<cmd>Markview toggle<cr>", mode = "n", desc = "Toggle MarkView" },
    },
    dependencies = { "saghen/blink.cmp" },
  },
}
