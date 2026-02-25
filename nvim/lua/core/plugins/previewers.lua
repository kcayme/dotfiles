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
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        -- all optional; sane defaults shown
        port = 8421,
        open_browser = true,
        debounce_ms = 300,
      })
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local presets = require("markview.presets").headings

      require("markview").setup({
        preview = {
          enable = false,
          icon_provider = "devicons", -- "mini" or "devicons"
          filetypes = { "markdown" },
        },
        markdown = { headings = presets.numbered },
      })
      local map = require("utils.keymap").map
      map("n", "<leader>md", "<CMD>Markview splitToggle<CR>", { desc = "Split toggles `markview` preview" })
    end,
  },
}
