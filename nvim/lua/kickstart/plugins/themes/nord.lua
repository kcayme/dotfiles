return {
  "shaunsingh/nord.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("nordic").load()
    -- require("nordic").()
  end,
}
