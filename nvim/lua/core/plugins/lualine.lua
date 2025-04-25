return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      -- local trouble = require("trouble")
      -- local symbols = trouble.statusline({
      --   mode = "lsp_document_symbols",
      --   groups = {},
      --   title = false,
      --   filter = { range = true },
      --   format = "{kind_icon}{symbol.name:Normal}",
      --   -- The following line is needed to fix the background color
      --   -- Set it to the lualine section you want to use
      --   hl_group = "lualine_c_normal",
      -- })
      local colors = require("base46").get_theme_tb("base_30")

      -- ref: https://github.com/NvChad/base46/blob/v3.0/lua/base46/themes/bearded-arc.lua
      local custom_theme = {
        normal = {
          a = { bg = colors.blue, fg = colors.black, gui = "bold" },
          b = { bg = colors.statusline_bg, fg = colors.white },
          c = { bg = colors.darker_black, fg = colors.white },
        },
        insert = {
          a = { bg = colors.green, fg = colors.black, gui = "bold" },
        },
        visual = {
          a = { bg = colors.purple, fg = colors.black, gui = "bold" },
        },
        replace = {
          a = { bg = colors.red, fg = colors.black, gui = "bold" },
        },
        command = {
          a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
        },
        inactive = {
          a = { bg = colors.darker_black, fg = colors.grey },
          b = { bg = colors.darker_black, fg = colors.grey },
          c = { bg = colors.darker_black },
        },
      }

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = custom_theme,
          -- component_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
          -- section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 100,
            -- tabline = 1000,
            -- winbar = 1000,
          },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icon = "" },
          },
          lualine_c = {
            { "diff", symbols = { added = " ", modified = " ", removed = " " } },
            {
              "diagnostics",
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
            },
            "filename",
            -- {
            --   symbols.get,
            --   cond = symbols.has,
            -- },
          },
          lualine_x = {
            "encoding",
            "searchcount",
          },
          lualine_y = {
            { "lsp_status", icon = "" },
            "filetype",
            "fileformat",
            -- "progress",
          },
          lualine_z = {
            "location",
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "nvim-tree", "mason", "trouble" },
      })
    end,
  },
}
