return {
  { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "nvchad/ui",
    config = function()
      require("nvchad")
    end,
  },
  {
    "nvchad/base46",
    lazy = true,
    priority = 1000,
    build = function()
      -- require("base46").compile()
      require("base46").load_all_highlights()
      vim.cmd.colorscheme("nvchad")
    end,
  },
}
