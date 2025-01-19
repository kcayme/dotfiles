return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        themable = true,
        numbers = "ordinal",
        always_show_bufferline = true,
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        --separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
        indicator = {
          style = "underline",
        },
      },
    },
  },
}
