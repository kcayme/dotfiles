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
  -- {
  --   "ibhagwan/fzf-lua",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   config = function()
  --     require("fzf-lua").setup({
  --       fzf_colors = true,
  --       "default",
  --       fzf = {
  --         match = "NvChHeadyellow",
  --       },
  --       keymap = {
  --         builtin = {
  --           ["<M-Esc>"] = "hide", -- hide fzf-lua, `:FzfLua resume` to continue
  --           ["<F1>"] = "toggle-help",
  --           ["<F2>"] = "toggle-fullscreen",
  --           -- Only valid with the 'builtin' previewer
  --           ["<F3>"] = "toggle-preview-wrap",
  --           ["<F4>"] = "toggle-preview",
  --           -- Rotate preview clockwise/counter-clockwise
  --           ["<F5>"] = "toggle-preview-ccw",
  --           ["<F6>"] = "toggle-preview-cw",
  --           -- `ts-ctx` binds require `nvim-treesitter-context`
  --           ["<F7>"] = "toggle-preview-ts-ctx",
  --           ["<F8>"] = "preview-ts-ctx-dec",
  --           ["<F9>"] = "preview-ts-ctx-inc",
  --           ["<S-Left>"] = "preview-reset",
  --           ["<C-d>"] = "preview-page-down",
  --           ["<C-u>"] = "preview-page-up",
  --           ["<M-S-down>"] = "preview-down",
  --           ["<M-S-up>"] = "preview-up",
  --         },
  --         fzf = {
  --           -- fzf '--bind=' options
  --           -- true,        -- uncomment to inherit all the below in your custom config
  --           ["ctrl-z"] = "abort",
  --           ["ctrl-u"] = "unix-line-discard",
  --           ["ctrl-f"] = "half-page-down",
  --           ["ctrl-b"] = "half-page-up",
  --           ["ctrl-a"] = "beginning-of-line",
  --           ["ctrl-e"] = "end-of-line",
  --           ["alt-a"] = "toggle-all",
  --           ["alt-g"] = "first",
  --           ["alt-G"] = "last",
  --           -- Only valid with fzf previewers (bat/cat/git/etc)
  --           ["f3"] = "toggle-preview-wrap",
  --           ["f4"] = "toggle-preview",
  --           ["shift-down"] = "preview-page-down",
  --           ["shift-up"] = "preview-page-up",
  --         },
  --       },
  --       defaults = { formatter = "path.dirname_first" },
  --       global = {
  --         file_icons = "devicons",
  --         -- defaults = { formatter = "path.filename_first" },
  --         -- no_ignore = true,
  --         cwd_prompt = false,
  --         cwd_prompt_shorten_len = 10,
  --       },
  --       winopts = {
  --         height = 0.80, -- window height
  --         width = 0.80, -- window width
  --         row = 0.50, -- window row position (0=top, 1=bottom)
  --         col = 0.50, -- window col position (0=left, 1=right)
  --         backdrop = 60,
  --         preview = {
  --           horizontal = "right:50%",
  --         },
  --       },
  --       grep = {
  --         prompt = "> ",
  --       },
  --       files = {
  --         cwd_prompt = false,
  --       },
  --       frecency = {
  --         display_score = false,
  --       },
  --     })
  --   end,
  -- },
}
