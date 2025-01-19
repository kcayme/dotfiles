return {
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
}
