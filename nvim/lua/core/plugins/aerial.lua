return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
  config = function()
    require("aerial").setup({
      -- This can be a filetype map (see :help aerial-filetype-map)
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

      layout = {
        default_direction = "right",
        placement = "edge",
        -- These control the width of the aerial window.
        -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a list of mixed types.
        -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
        max_width = { 40, 0.2 },
        min_width = 45,
      },
      highlight_on_hover = true,
      autojump = true,
      show_guides = true,
      float = {
        relative = "editor",
      },
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        -- vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
        -- vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>")
      end,
    })
  end,
}
