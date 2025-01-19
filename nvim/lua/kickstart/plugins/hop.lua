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
      map("n", "<Leader>hw", "<cmd>HopCamelCase<CR>", { noremap = true, desc = "Hop next words" })
      map("n", "<Leader>hj", "<cmd>HopLineStart<CR>", { noremap = true, desc = "Hop next line" })
      map("n", "<Leader>hp", "<cmd>HopPattern<CR>", { noremap = true, desc = "Hop pattern" })
      map({ "n", "v" }, "<Leader>he", function()
        -- hop.hint_words({ hint_position = hop_position.END })
        hop.hint_camel_case({ hint_position = hop_position.END })
      end, { noremap = true })

      -- visual mode (easymotion-like)
      vim.api.nvim_set_keymap("v", "<Leader>hw", "<cmd>HopWordAC<CR>", { noremap = true })
      vim.api.nvim_set_keymap("v", "<Leader>hb", "<cmd>HopWordBC<CR>", { noremap = true })
      vim.api.nvim_set_keymap("v", "<Leader>hj", "<cmd>HopLineStart<CR>", { noremap = true })
    end,
  },
}
