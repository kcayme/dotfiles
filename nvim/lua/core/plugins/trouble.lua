return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      modes = {
        diagnostics = {
          mode = "diagnostics",
          -- preview = {
          --   type = "split",
          --   relative = "win",
          --   position = "right",
          --   size = 0.2,
          -- },
        },
      },
    },
    keys = {
      {
        "<leader>tx",
        "<cmd>Trouble diagnostics toggle focus=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
      -- {
      --   "<leader>tx",
      --   "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      --   desc = "Buffer Diagnostics (Trouble)",
      -- },
      -- {
      --   "<leader>tt",
      --   "<cmd>Trouble todo toggle<cr>",
      --   desc = "Todo List (Trouble)",
      -- },
      -- {
      --   "<leader>ts",
      --   "<cmd>Trouble symbols toggle focus=false<cr>",
      --   desc = "Symbols (Trouble)",
      -- },
      -- {
      --   "<leader>tl",
      --   "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      --   desc = "LSP Definitions / references / ... (Trouble)",
      -- },
      -- {
      --   "<leader>tL",
      --   "<cmd>Trouble loclist toggle<cr>",
      --   desc = "Location List (Trouble)",
      -- },
      -- {
      --   "<leader>tq",
      --   "<cmd>Trouble qflist toggle<cr>",
      --   desc = "Quickfix List (Trouble)",
      -- },
    },
    -- config = function()
    -- map("n", "<leader>tx", function()
    --   require("trouble").toggle()
    -- end, { desc = "Trouble Toggle" })
    -- map("n", "<leader>tw", function()
    --   require("trouble").toggle("workspace_diagnostics")
    -- end, { desc = "Trouble Workspace Diagnostics" })
    -- map("n", "<leader>td", function()
    --   require("trouble").toggle("document_diagnostics")
    -- end, { desc = "Trouble Document Diagnostics" })
    -- map("n", "<leader>tq", function()
    --   require("trouble").toggle("quickfix")
    -- end, { desc = "Trouble Quickfix" })
    -- map("n", "<leader>tl", function()
    --   require("trouble").toggle("loclist")
    -- end, { desc = "Trouble Loclist" })
    -- map("n", "tR", function()
    --   require("trouble").toggle("lsp_references")
    -- end, { desc = "Trouble LSP References" })
    -- end,
  },
}
