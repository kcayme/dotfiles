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

      local statusline = require("arrow.statusline") -- from arrow documentation
      local function arrow_status() -- from lualine documentation
        return statusline.text_for_statusline_with_icons()
      end

      local custom_theme = nil

      local colors = require("utils.colors").get_base30_palette()
      if colors then
        -- ref: https://github.com/NvChad/base46/blob/v3.0/lua/base46/themes/bearded-arc.lua
        custom_theme = {
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
      end

      local custom_signs = require("core.themes.signs")

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = custom_theme,
          section_separators = { left = "", right = "" },
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
            winbar = 100,
          },
        },

        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icon = "" },
          },
          lualine_c = {
            {
              "diff",
              symbols = {
                added = custom_signs.added,
                modified = custom_signs.modified,
                removed = custom_signs.removed,
              },
            },
            "filename",
            {
              "diagnostics",
              symbols = {
                error = custom_signs.error,
                warn = custom_signs.warn,
                info = custom_signs.info,
                hint = custom_signs.hint,
              },
            },
            arrow_status,
            -- "aerial",
            {
              "macro",
              fmt = function()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then
                  return "Recording @" .. reg
                end
                return nil
              end,
              color = colors and { fg = colors.yellow },
              draw_empty = false,
            },
            -- {
            --   symbols.get,
            --   cond = symbols.has,
            -- },
          },
          lualine_x = {
            "encoding",
            "searchcount",
            {
              function()
                local status = require("sidekick.status").cli()
                return " " .. (#status > 1 and #status or "")
              end,
              cond = function()
                return #require("sidekick.status").cli() > 0
              end,
            },
          },
          lualine_y = {
            {
              "lsp_status",
              icon = "",
              ignore_lsp = { "typos_lsp" },
            },
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
        winbar = {
          lualine_c = {
            "aerial",
          },
        },
        inactive_winbar = {},
        extensions = {
          "nvim-tree",
          "fzf",
          "lazy",
          "oil",
          "mason",
          "trouble",
        },
      })
    end,
  },
}
