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

  {
    "kcayme/md-view.nvim",
    opts = {
      theme = "sync",
      auto_open = {
        enable = true,
      },
    },
  },
}
