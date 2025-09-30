return {
  "rachartier/tiny-code-action.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    {
      "folke/snacks.nvim",
      opts = {
        terminal = {},
      },
    },
  },
  event = "LspAttach",
  opts = {
    backend = "vim",
    picker = {
      "snacks",
      -- "buffer",
      -- opts = {
      --   hotkeys = true,
      --   position = "cursor",
      --   auto_preview = true,
      -- },
    },
  },
}
