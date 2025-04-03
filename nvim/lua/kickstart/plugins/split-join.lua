return {
  "Wansmer/treesj",
  -- keys = { "<space>m", "<space>j", "<space>s" },
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require("treesj").setup({--[[ your config ]]
      use_default_keymaps = false,
    })

    local map = vim.keymap.set
    map("n", "J", "<cmd>TSJToggle<cr>", {})
  end,
}
