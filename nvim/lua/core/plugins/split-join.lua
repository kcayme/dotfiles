return {
  "Wansmer/treesj",
  keys = {
    { "<leader>J", "<cmd>TSJToggle<cr>", desc = "Toggle split/join" },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  }, -- if you install parsers with `nvim-treesitter`
  opts = {
    use_default_keymaps = false,
    max_join_length = 500,
  },
}
