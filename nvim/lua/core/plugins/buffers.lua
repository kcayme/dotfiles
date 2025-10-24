return {
  -- {
  --   "akinsho/bufferline.nvim",
  --   dependencies = {
  --     "folke/snacks.nvim",
  --   },
  --   config = function()
  --     local highlights = nil
  --     local colors = require("utils.colors").get_base30_palette()
  --     if colors then
  --       highlights = {
  --         fill = {
  --           bg = colors.darker_black,
  --         },
  --         separator = {
  --           -- bg = colors.black,
  --           fg = colors.darker_black,
  --         },
  --         separator_visible = {
  --           -- bg = colors.black,
  --           fg = colors.darker_black,
  --         },
  --         separator_selected = {
  --           -- bg = colors.black,
  --           fg = colors.darker_black,
  --         },
  --         trunc_marker = {
  --           bg = colors.darker_black,
  --           -- bg = "<colour-value-here>",
  --         },
  --       }
  --     end
  --
  --     require("bufferline").setup({
  --       highlights = highlights,
  --       options = {
  --         themable = true,
  --         -- numbers = "both",
  --         numbers = function(opts)
  --           return string.format("%s %s", opts.ordinal, opts.raise(opts.id))
  --         end,
  --         always_show_bufferline = true,
  --         separator_style = "thin", -- "slant" | "slope" | "thick" | "thin"
  --         diagnostics = "nvim_lsp",
  --         --- count is an integer representing total count of errors
  --         --- level is a string "error" | "warning"
  --         --- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
  --         --- this should return a string
  --         diagnostics_indicator = function(count, level, diagnostics_dict, context)
  --           if not context.buffer:current() then
  --             return ""
  --           end
  --           local s = " "
  --           local order = { "error", "warning", "info", "hint" }
  --           local symbols = {
  --             error = " ",
  --             warning = " ",
  --             hint = " ",
  --             info = " ",
  --           }
  --
  --           for _, severity in ipairs(order) do
  --             local n = diagnostics_dict[severity]
  --             if n and n > 0 then
  --               s = s .. n .. symbols[severity]
  --             end
  --           end
  --           return s
  --         end,
  --         --separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
  --         indicator = {
  --           icon = "▎", -- this should be omitted if indicator style is not 'icon'
  --           style = "icon",
  --         },
  --         pick = {
  --           alphabet = "1234567890abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ",
  --         },
  --         close_command = function()
  --           Snacks.bufdelete()
  --         end,
  --         offsets = {
  --           {
  --             filetype = "NvimTree",
  --             -- text = "File Explorer",
  --             text_align = "left",
  --             text = function()
  --               return "Directory: " .. vim.fn.getcwd()
  --             end,
  --             separator = true, -- use a "true" to enable the default, or set your own character
  --           },
  --         },
  --         custom_areas = {
  --           right = function()
  --             local bufferline = require("bufferline")
  --             local buffers = bufferline.get_elements().elements
  --             local count = #buffers
  --
  --             return {
  --               {
  --                 text = "%#RoundedEdge#%#RoundedInner#  Buffers: " .. tostring(count) .. " %#RoundedEdge#",
  --               },
  --             }
  --           end,
  --         },
  --       },
  --     })
  --
  --     local map = vim.keymap.set
  --     map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", {})
  --     map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", {})
  --     map("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick Close buffer" })
  --     map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pick Close buffer" })
  --     map("n", "<leader>bC", function()
  --       Snacks.bufdelete.other()
  --     end, { desc = "Close other buffers" })
  --     map("n", "<leader>bs", "<cmd>BufferLinePick<cr>", {})
  --   end,
  -- },
  {
    "willothy/nvim-cokeline",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for v0.4.0+
      "nvim-tree/nvim-web-devicons", -- If you want devicons
    },
    config = function()
      local is_picking_focus = require("cokeline.mappings").is_picking_focus
      local is_picking_close = require("cokeline.mappings").is_picking_close
      local colors = require("utils.colors").get_base30_palette()

      require("cokeline").setup({
        fill_hl = "RoundedInnerInactive",

        components = {
          {
            text = function(buffer)
              return buffer.is_focused and "" or " "
            end,
            highlight = function(buffer)
              return buffer.is_focused and "RoundedEdgeActive" or "RoundedEdgeInactive"
            end,
          },
          {
            text = function(buffer)
              return ""
                .. (
                  (is_picking_focus() or is_picking_close()) and not buffer.is_focused and buffer.pick_letter .. " "
                  or buffer.devicon.icon
                )
            end,
            fg = function(buffer)
              return (is_picking_focus() and not buffer.is_focused and (colors and colors.yellow))
                or (is_picking_close() and not buffer.is_focused and (colors and colors.red))
                or (buffer.is_focused and (colors and colors.darker_black))
                or buffer.devicon.color
            end,
            bg = function(buffer)
              return (is_picking_focus() and not buffer.is_focused and (colors and colors.darker_black))
                or (is_picking_close() and not buffer.is_focused and (colors and colors.darker_black))
                or (buffer.is_focused and (colors and colors.blue))
                or colors and colors.darker_black
            end,
            italic = function(buffer)
              return (is_picking_focus() or is_picking_close()) and not buffer.is_focused
            end,
            bold = function(buffer)
              return (is_picking_focus() or is_picking_close()) and not buffer.is_focused
            end,
          },
          -- {
          --   text = function(buffer)
          --     return buffer.devicon.icon
          --   end,
          --   highlight = function(buffer)
          --     return buffer.is_focused and "RoundedInnerActive" or "RoundedInnerInactive"
          --   end,
          -- },
          {
            text = function(buffer)
              return buffer.unique_prefix
            end,
            highlight = function(buffer)
              return buffer.is_focused and "RoundedInnerActiveSecondary" or "RoundedInnerInactiveSecondary"
            end,
          },
          {
            text = function(buffer)
              return buffer.filename .. " "
            end,
            style = function(buffer)
              return buffer.is_focused and "bold" or nil
            end,
            highlight = function(buffer)
              return buffer.is_focused and "RoundedInnerActive" or "RoundedInnerInactive"
            end,
          },
          {
            text = function()
              return ""
            end,
            delete_buffer_on_left_click = true,
            highlight = function(buffer)
              return buffer.is_focused and "RoundedInnerActive" or "RoundedInnerInactive"
            end,
          },
          {
            text = function(buffer)
              return buffer.is_focused and " " or " "
            end,
            highlight = function(buffer)
              return buffer.is_focused and "RoundedEdgeActive" or "RoundedEdgeInactive"
            end,
          },
          {
            text = function(buffer)
              if buffer.diagnostics.errors > 0 then
                return "  " .. buffer.diagnostics.errors
              end
              return ""
            end,
            fg = function()
              return colors and colors.red
            end,
            bg = function()
              return colors and colors.darker_black
            end,
          },
          {
            text = function(buffer)
              if buffer.diagnostics.warnings > 0 then
                return "  " .. buffer.diagnostics.warnings
              end
              return ""
            end,
            fg = function()
              return colors and colors.yellow
            end,
            bg = function()
              return colors and colors.darker_black
            end,
          },
          {
            text = function(buffer)
              if buffer.diagnostics.infos > 0 then
                return "  " .. buffer.diagnostics.infos
              end
              return ""
            end,
            fg = function(_)
              return colors and colors.green
            end,
            bg = function(_)
              return colors and colors.darker_black
            end,
          },
          {
            text = function(buffer)
              return buffer.is_modified and " " or ""
            end,
            fg = function(buffer)
              return buffer.is_modified and colors and colors.green or colors and colors.darker_black
            end,
            bg = function(buffer)
              return buffer.is_modified and colors and colors.darker_black or colors and colors.darker_black
            end,
          },
          {
            text = "  ",
            fg = colors and colors.statusline_bg,
            bg = colors and colors.darker_black,
          },
        },
      })

      local map = vim.keymap.set
      map("n", "<S-h>", "<Plug>(cokeline-focus-prev)", {})
      map("n", "<S-l>", "<Plug>(cokeline-focus-next)", {})
      map("n", "<leader>bC", function()
        Snacks.bufdelete.other()
      end, { desc = "Close other buffers" })
      map("n", "<leader>bs", function()
        require("cokeline.mappings").pick("focus") -- FIXME:
      end, {})
    end,
  },
}
