return {
  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    opts = {},
    config = function()
      require("Comment").setup()

      local map = vim.api.nvim_set_keymap
      map("n", "<C-/>", "gcc", { noremap = false, desc = "Toggle linewise comment" })
      map("v", "<C-/>", "gb", { noremap = false, desc = "Toggle blockwise comment" })
    end,
  },
}
