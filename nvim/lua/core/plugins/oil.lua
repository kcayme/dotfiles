return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    config = function()
      require("oil").setup({
        columns = {
          "icon",
        },
        win_options = {
          wrap = false,
          signcolumn = "yes:1",
          -- signcolumn = "no",
          cursorcolumn = false,
          foldcolumn = "0",
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = "nvic",
        },
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = "actions.preview",
          ["q"] = { "actions.close", mode = "n" },
          ["<C-l>"] = "actions.refresh",
          ["-"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gx"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        view_options = {
          -- Show files and directories that start with "."
          show_hidden = true,
        },
        -- Configuration for the floating window in oil.open_float
        float = {
          -- Padding around the floating window
          padding = 2,
          -- max_width and max_height can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          max_width = 0.8,
          max_height = 0.8,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
          -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
          get_win_title = nil,
          -- preview_split: Split direction: "auto", "left", "right", "above", "below".
          preview_split = "auto",
          -- This is the config that will be passed to nvim_open_win.
          -- Change values here to customize the layout
          override = function(conf)
            return conf
          end,
        },
        confirmation = {
          -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a single value or a list of mixed integer/float types.
          -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
          max_width = 0.9,
          -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
          min_width = { 40, 0.4 },
          -- optionally define an integer/float for the exact width of the preview window
          width = nil,
          -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_height and max_height can be a single value or a list of mixed integer/float types.
          -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
          max_height = 0.9,
          -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
          min_height = { 5, 0.1 },
          -- optionally define an integer/float for the exact height of the preview window
          height = nil,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
      })

      local map = vim.keymap.set
      map("n", "<leader>-", "<cmd>Oil --float<cr>", { desc = "Open parent directory" })
    end,
  },
  {
    "refractalize/oil-git-status.nvim",

    dependencies = {
      "stevearc/oil.nvim",
    },

    config = true,
  },
}
