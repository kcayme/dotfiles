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
        mode = "dark",
      },
      auto_open = {
        enable = false,
      },
      scroll = {
        method = "cursor", -- "percentage" | "cursor"
      },
      single_page = {
        enable = true,
        close_by = "page",
      },
      table_of_contents = {
        enable = true,
      },
    },
  },
  {
    url = "https://forge.barrettruth.com/barrettruth/live-server.nvim",
  },
  {
    "kcayme/jlog.nvim",
    config = function()
      require("jlog").setup({
        fields = {
          time = { "time", "ts", "timestamp", "@timestamp" },
          level = { "level", "lvl", "severity" },
          message = { "msg", "message" },
          status = { "status", "status_code" },
        },
        compact = {
          style = "plain",
          order = {},
          fields = {},
          pill = { left = "\238\130\182", right = "\238\130\180" },
          style_values = { "level", "status" },
        },
        view = { mode = "compact", sort = "desc", field_colors = true },
        unwrap = { enable = true, max_depth = 4 },
        sidebar = {
          width = 45,
          position = "right",
          field_colors = true,
          style = "plain",
          fields = {},
          pill = { left = "\238\130\182", right = "\238\130\180" },
        },
        facets = { top_values = 10 },
        paging = { size = 100000, overlap = 2000 },
        progress = "auto",
        keymaps = {
          toggle_entry = "<CR>",
          toggle_mode = "E",
          raw = "gf",
          reverse = "R",
          next_entry = "]]",
          prev_entry = "[[",
          next_error = "]e",
          prev_error = "[e",
          next_page = "]p",
          prev_page = "[p",
          focus_sidebar = "s",
          toggle_sidebar = "S",
          close = "q",
          add_filter = "<CR>",
          group_by = "g",
          help = "?",
        },
      })
    end,
  },
}
