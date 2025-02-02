return {

  "folke/tokyonight.nvim",
  lazy = false,
  --priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "storm",
      dim_inactive = true, -- dims inactive windows
      -- lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
    })
    vim.cmd([[colorscheme tokyonight]])
  end,
}
