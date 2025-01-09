return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        -- light = "latte",
        -- dark = "latte",
      },
      transparent_background = false, -- disables setting the background color.
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.6, -- percentage of the shade to apply to the inactive window
      },
      -- no_italic = false, -- Force no italic
      -- no_bold = false, -- Force no bold
      -- no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
      },
      highlight_overrides = {
        -- all = function(colors)
        --   return {
        --     CurSearch = { bg = colors.sky },
        --     IncSearch = { bg = colors.sky },
        --     CursorLineNr = { fg = colors.blue, style = { "bold" } },
        --     DashboardFooter = { fg = colors.overlay0 },
        --     TreesitterContextBottom = { style = {} },
        --     WinSeparator = { fg = colors.overlay0, style = { "bold" } },
        --     ["@markup.italic"] = { fg = colors.blue, style = { "italic" } },
        --     ["@markup.strong"] = { fg = colors.blue, style = { "bold" } },
        --     Headline = { style = { "bold" } },
        --     Headline1 = { fg = colors.blue, style = { "bold" } },
        --     Headline2 = { fg = colors.pink, style = { "bold" } },
        --     Headline3 = { fg = colors.lavender, style = { "bold" } },
        --     Headline4 = { fg = colors.green, style = { "bold" } },
        --     Headline5 = { fg = colors.peach, style = { "bold" } },
        --     Headline6 = { fg = colors.flamingo, style = { "bold" } },
        --     rainbow1 = { fg = colors.blue, style = { "bold" } },
        --     rainbow2 = { fg = colors.pink, style = { "bold" } },
        --     rainbow3 = { fg = colors.lavender, style = { "bold" } },
        --     rainbow4 = { fg = colors.green, style = { "bold" } },
        --     rainbow5 = { fg = colors.peach, style = { "bold" } },
        --     rainbow6 = { fg = colors.flamingo, style = { "bold" } },
        --   }
        -- end,
      },
      color_overrides = {
        all = {
          rosewater = "#f5e0dc",
          flamingo = "#f2cdcd",
          pink = "#f5c2e7",
          mauve = "#cba6f7",
          red = "#f38ba8",
          maroon = "#eba0ac",
          peach = "#fab387",
          yellow = "#f9e2af",
          green = "#a6e3a1",
          teal = "#94e2d5",
          sky = "#89dceb",
          sapphire = "#74c7ec",
          blue = "#89b4fa",
          lavender = "#b4befe",
          text = "#cdd6f4",
          subtext1 = "#bac2de",
          subtext0 = "#a6adc8",
          overlay2 = "#9399b2",
          overlay1 = "#7f849c",
          overlay0 = "#6c7086",
          surface2 = "#585b70",
          surface1 = "#45475a",
          surface0 = "#313244",
          base = "#1b2536",
          mantle = "#181825",
          crust = "#11111b",
        },
      },
      integrations = {
        telescope = {
          enabled = true,
        },
        cmp = true,
        gitsigns = true,
        nvimtree = false,
        treesitter = true,
        notify = true,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    })

    -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")
  end,
}
