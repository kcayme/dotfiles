return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    dependencies = { "folke/todo-comments.nvim" },
    ---@type snacks.Config
    ---@class snacks.indent.Config
    opts = {
      input = {
        icon = " ",
        icon_hl = "SnacksInputIcon",
        icon_pos = "right",
        prompt_pos = "title",
        win = {
          style = "input",
          border = "rounded",
          title_pos = "center",
          noautocmd = true,
          row = 0.25,
          width = 65,
          height = 1,
        },
        expand = true,
      },
      indent = {
        enabled = true,
        animate = {
          enabled = vim.fn.has("nvim-0.10") == 1,
          style = "out",
          duration = {
            step = 50,
            total = 100,
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
            -- reverse = true,
            -- layout = {
            --   box = "horizontal",
            width = 0.8,
            min_width = 120,
            height = 0.9,
            --   {
            --     box = "vertical",
            --     border = "rounded",
            --     title = "{title} {live} {flags}",
            --     { win = "list", border = "none" },
            --     {
            --       win = "input",
            --       height = 1,
            --       border = "top",
            --       title = "{title} {live} {flags}",
            --       title_pos = "center",
            --     },
            --   },
            --   {
            --     win = "preview",
            --     title = "{preview:Preview}",
            --     width = 0.5,
            --     border = "rounded",
            --     title_pos = "center",
            --   },
            --   --   { win = "preview", title = "{preview:Preview}", border = "rounded", width = 0.5 },
            -- },
          },
        },
        win = {
          input = {
            keys = {
              ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<c-l>"] = { "edit_vsplit", mode = { "i", "n" } },
              ["<c-h>"] = { "edit_split", mode = { "i", "n" } },
            },
          },
        },
      },
      bufdelete = {},
    },
  },
  {
    "dmtrKovalenko/fff.nvim",
    dependencies = { "saghen/blink.cmp" },
    build = function()
      -- this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
    end,
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
        show_scores = false,
      },
      layout = {
        width = 0.80,
        height = 0.80, -- Window height as fraction of screen
      },
    },
  },
}
