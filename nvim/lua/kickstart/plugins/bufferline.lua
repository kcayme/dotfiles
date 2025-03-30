return {
  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          themable = true,
          numbers = "buffer_id",
          always_show_bufferline = true,
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          --separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          indicator = {
            icon = "▎", -- this should be omitted if indicator style is not 'icon'
            style = "icon",
          },
          pick = {
            alphabet = "1234567890abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ",
          },
        },
      })

      local map = vim.keymap.set
      map("n", ")", "<cmd>BufferLineMoveNext<cr>", {})
      map("n", "(", "<cmd>BufferLineMovePrev<cr>", {})
      map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", {})
      map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", {})
      map("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })
      map("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick Close buffer" })
      map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pick Close buffer" })
      map("n", "<leader>bC", "<cmd>BufferLineCloseOthers<cr>", { desc = "Pick Close others" })
      map("n", "<leader>bs", "<cmd>BufferLinePick<cr>", {})
      for i = 1, 5, 1 do
        map(
          "n",
          string.format("<leader>%d", i),
          string.format("<cmd>BufferLineGoToBuffer %d<cr>", i),
          { desc = "Pick buffer by visible position" }
        )
      end
    end,
  },
}
