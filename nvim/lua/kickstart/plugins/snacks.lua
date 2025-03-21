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
      picker = {
        files = {},
        smart = {},
        layouts = {
          default = {
            reverse = true,
            layout = {
              box = "horizontal",
              width = 0.8,
              min_width = 120,
              height = 0.9,
              {
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                { win = "list", border = "none" },
                {
                  win = "input",
                  height = 1,
                  border = "top",
                  title = "{title} {live} {flags}",
                  title_pos = "center",
                },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.5,
                border = "rounded",
                title_pos = "center",
              },
              --   { win = "preview", title = "{preview:Preview}", border = "rounded", width = 0.5 },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>br",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
      -- {
      --   "<leader>gB",
      --   function()
      --     Snacks.gitbrowse()
      --   end,
      --   desc = "Git Browse",
      --   mode = { "n", "v" },
      -- },
      -- {
      --   "<leader>gb",
      --   function()
      --     Snacks.git.blame_line()
      --   end,
      --   desc = "Git Blame Line",
      -- },
      {
        "<leader>gf",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      -- pickers
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader><leader>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fs",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>ft",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Find Git Files",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      -- Grep
      {
        "<leader>fl",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>fw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      {
        "<leader>fd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>fh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>fk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>fq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
    },
  },
}
