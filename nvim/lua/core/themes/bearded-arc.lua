return {
  {
    -- dir = vim.fn.expand("~/bearded-arc.nvim"),
    "kcayme/bearded-arc.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bearded-arc").setup({})
      vim.cmd.colorscheme("bearded-arc")
    end,
  },
}
