return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      require("bufferline").setup({
        options = {
          themable = true,
          -- numbers = "both",
          numbers = function(opts)
            return string.format("%s %s", opts.ordinal, opts.raise(opts.id))
          end,
          always_show_bufferline = true,
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            -- local icon = level:match("error") and " " or " "
            -- return " " .. icon .. count
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or " ")
              s = s .. n .. sym
              if e == "error" then
                s = s .. count
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
