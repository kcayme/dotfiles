return {
  {
    "dmtrKovalenko/fff.nvim",
    build = "cargo build --release",
    opts = {
      keymaps = {
        close = "<Esc>",
        select = "<CR>",
        select_split = "<C-s>",
        select_vsplit = "<C-v>",
        select_tab = "<C-t>",
        move_up = { "<Up>", "<C-k>" }, -- Multiple bindings supported
        move_down = { "<Down>", "<C-j>" }, -- Multiple bindings supported
        preview_scroll_up = "<C-u>",
        preview_scroll_down = "<C-d>",
      },
      debug = {
        show_scores = true, -- We hope for your collaboratio
      },
    },
    keys = {
      {
        "<leader>ff", -- try it if you didn't it is a banger keybinding for a picker
        function()
          require("fff").find_files()
        end,
        desc = "FFF Find Files",
      },
    },
  },
}
