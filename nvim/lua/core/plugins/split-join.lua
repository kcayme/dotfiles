return {
  "Wansmer/treesj",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  }, -- if you install parsers with `nvim-treesitter`
  config = function()
    require("treesj").setup({
      use_default_keymaps = false,
      max_join_length = 500,
    })

    local map = vim.keymap.set
    map("n", "<leader>J", "<cmd>TSJToggle<cr>", {})
  end,
}
