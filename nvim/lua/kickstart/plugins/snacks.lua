return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    ---@class snacks.indent.Config
    opts = {
      indent = {
        enabled = true,
        animate = {
          style = "out",
          duration = {
            step = 50,
            total = 150,
          },
        },
        scope = {
          enabled = true,
          priority = 200,
        },
        chunk = {
          enabled = false,
        },
      },
      statuscolumn = { enabled = true },
    },
    keys = {
      {
        "<leader>br",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      {
        "<leader>gB",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
      {
        "<leader>gb",
        function()
          Snacks.git.blame_line()
        end,
        desc = "Git Blame Line",
      },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
    },
  },
}
