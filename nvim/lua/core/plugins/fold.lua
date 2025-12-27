return {
  {
    "chrisgrieser/nvim-origami",
    event = "VeryLazy",
    opts = {}, -- needed even when using default config
    init = function() end,
    config = function()
      require("origami").setup({
        useLspFoldsWithTreesitterFallback = { enabled = true },
        pauseFoldsOnSearch = true,
        foldtext = {
          enabled = true,
          padding = 3,
          lineCount = {
            template = "%d lines", -- `%d` is replaced with the number of folded lines
            hlgroup = "Comment",
          },
          diagnosticsCount = true, -- uses hlgroups and icons from `vim.diagnostic.config().signs`
          gitsignsCount = true, -- requires `gitsigns.nvim`
        },
        autoFold = {
          enabled = false,
          -- kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
        },
        foldKeymaps = {
          setup = true, -- modifies `h`, `l`, and `$`
          hOnlyOpensOnFirstColumn = false,
        },
      })
    end,
  },
}
