return {
  -- { "nvim-tree/nvim-web-devicons", lazy = true },
  {
    "nvchad/ui", -- must be enabled for nvchad theme to apply
    config = function()
      require("nvchad")
    end,
  },
  {
    "nvchad/base46",
    lazy = false,
    priority = 1000,
    build = function()
      require("base46").load_all_highlights()
      vim.cmd.colorscheme("nvchad")
    end,
  },
}
