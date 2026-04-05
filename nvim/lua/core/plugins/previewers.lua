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
    "kcayme/md-view.nvim",
    opts = {
      theme = {
        mode = "sync",
      },
      auto_open = {
        enable = false,
      },
      scroll = {
        method = "cursor", -- "percentage" | "cursor"
      },
      single_page = {
        enable = false,
        close_by = "page",
      },
      table_of_contents = {
        enable = true,
      },
    },
  },
  {
    "barrettruth/live-server.nvim",
  },
}
