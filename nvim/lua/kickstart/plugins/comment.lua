return {
  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    opts = {},
    config = function()
      require("Comment").setup()

      local map = vim.api.nvim_set_keymap
      map("n", "<C-_>", "gcc", { noremap = false, desc = "Toggle linewise comment" })
      map("v", "<C-_>", "gb", { noremap = false, desc = "Toggle blockwise comment" })
    end,
  },
}
