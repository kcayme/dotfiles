return {
  -- Hop-like plugins
  {
    "smoka7/hop.nvim",
    version = "*", -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup({
        keys = "etovxqpdygfblzhckisuran",
        multi_windows = true,
      })

      local map = vim.keymap.set
      local hop = require("hop")
      local hop_position = require("hop.hint").HintPosition

      map("n", "<Leader>hb", "<cmd>HopWordBC<CR>", { noremap = true, desc = "Hop prev words" })
      map({ "n", "v" }, "<Leader>w", "<cmd>HopCamelCase<CR>", { noremap = true, desc = "Hop next words" })
      map("n", "<Leader>hp", "<cmd>HopPattern<CR>", { noremap = true, desc = "Hop pattern" })
      map({ "n", "v" }, "<Leader>he", function()
        hop.hint_words({ hint_position = hop_position.END })
      end, { noremap = true, desc = "Hop end of word" })
    end,
  },
}
