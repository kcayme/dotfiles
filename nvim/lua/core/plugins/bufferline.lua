return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      local highlights = nil
      local ok, base46 = pcall(require, "base46")
      if ok then
        local colors = base46.get_theme_tb("base_30")
        highlights = {
          fill = {
            bg = colors.darker_black,
          },
          separator = {
            -- bg = colors.black,
            fg = colors.darker_black,
          },
          separator_visible = {
            -- bg = colors.black,
            fg = colors.darker_black,
          },
          separator_selected = {
            -- bg = colors.black,
            fg = colors.darker_black,
          },
          trunc_marker = {
            bg = colors.darker_black,
            -- bg = "<colour-value-here>",
          },
        }
      end

      require("bufferline").setup({
        highlights = highlights,
        options = {
          themable = true,
          -- numbers = "both",
          numbers = function(opts)
            return string.format("%s %s", opts.ordinal, opts.raise(opts.id))
          end,
          always_show_bufferline = true,
          separator_style = "thin", -- "slant" | "slope" | "thick" | "thin"
          diagnostics = "nvim_lsp",
          --- count is an integer representing total count of errors
          --- level is a string "error" | "warning"
          --- diagnostics_dict is a dictionary from error level ("error", "warning" or "info")to number of errors for each level.
          --- this should return a string
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            if not context.buffer:current() then
              return ""
            end
            local s = " "
            local order = { "error", "warning", "info", "hint" }
            local symbols = {
              error = " ",
              warning = " ",
              hint = " ",
              info = " ",
            }

            for _, severity in ipairs(order) do
              local n = diagnostics_dict[severity]
              if n and n > 0 then
                s = s .. n .. symbols[severity]
              end
            end
            return s
          end,
          --separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          indicator = {
            icon = "▎", -- this should be omitted if indicator style is not 'icon'
            style = "icon",
          },
          pick = {
            alphabet = "1234567890abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ",
          },
          close_command = function()
            Snacks.bufdelete()
          end,
          offsets = {
            {
              filetype = "NvimTree",
              -- text = "File Explorer",
              text_align = "left",
              text = function()
                return "Directory: " .. vim.fn.getcwd()
              end,
              separator = true, -- use a "true" to enable the default, or set your own character
            },
          },
          custom_areas = {
            left = function()
              local bufferline = require("bufferline")
              local buffers = bufferline.get_elements().elements
              local count = #buffers

              local result = {
                {
                  text = " Buffers: " .. tostring(count) .. " ",
                  link = "BufferLineInfo",
                },
              }
              return result
            end,
          },
        },
      })

      local map = vim.keymap.set
      map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", {})
      map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", {})
      map("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick Close buffer" })
      map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pick Close buffer" })
      map("n", "<leader>bC", function()
        Snacks.bufdelete.other()
      end, { desc = "Close other buffers" })
      map("n", "<leader>bs", "<cmd>BufferLinePick<cr>", {})
    end,
  },
}
