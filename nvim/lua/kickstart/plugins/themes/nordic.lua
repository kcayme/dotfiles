return {
  "AlexvZyl/nordic.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("nordic").setup({
      -- This callback can be used to override the colors used in the palette.
      on_palette = function(palette)
        palette.gray0 = "#222A38"
        return palette
      end,
      -- on_highlight = function(highlights, palette)
      --   highlights.TelescopePromptTitle = {
      --     fg = palette.red.bright,
      --     bg = palette.green.base,
      --     italic = true,
      --     underline = true,
      --     sp = palette.yellow.dim,
      --     undercurl = false,
      --   }
      -- end,
      -- Enable bold keywords.
      bold_keywords = false,
      -- Enable italic comments.
      italic_comments = true,
      -- Enable general editor background transparency.
      transparent = {
        -- Enable transparent background.
        bg = false,
        -- Enable transparent background for floating windows.
        float = false,
      },
      -- Enable brighter float border.
      bright_border = true,
      -- Reduce the overall amount of blue in the theme (diverges from base Nord).
      reduced_blue = false,
      -- Swap the dark background with the normal one.
      swap_backgrounds = false,
      -- Cursorline options.  Also includes visual/selection.
      cursorline = {
        -- Bold font in cursorline.
        bold = true,
        -- Bold cursorline number.
        bold_number = true,
        -- Available styles: 'dark', 'light'.
        theme = "light",
        -- Blending the cursorline bg with the buffer bg.
        blend = 0.80,
      },
      noice = {
        -- Available styles: `classic`, `flat`.
        style = "flat",
      },
      telescope = {
        -- Available styles: `classic`, `flat`.
        style = "flat",
      },
      leap = {
        -- Dims the backdrop when using leap.
        dim_backdrop = false,
      },
      ts_context = {
        -- Enables dark background for treesitter-context window
        dark_background = true,
      },
    })
    require("nordic").load()
  end,
}
