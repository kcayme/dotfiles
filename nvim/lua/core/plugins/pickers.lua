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
        sources = {
          files = { hidden = true, ignored = false },
          smart = { hidden = true, ignored = false },
        },
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
      terminal = {},
      image = {
        ---@class snacks.image.Config
        ---@field enabled? boolean enable image viewer
        ---@field wo? vim.wo|{} options for windows showing the image
        ---@field bo? vim.bo|{} options for the image buffer
        ---@field formats? string[]
        --- Resolves a reference to an image with src in a file (currently markdown only).
        --- Return the absolute path or url to the image.
        --- When `nil`, the path is resolved relative to the file.
        ---@field resolve? fun(file: string, src: string): string?
        ---@field convert? snacks.image.convert.Config
        enabled = true,
        formats = {
          "png",
          "svg",
          "jpg",
          "jpeg",
          "gif",
          "bmp",
          "webp",
          "tiff",
          "heic",
          "avif",
          "mp4",
          "mov",
          "avi",
          "mkv",
          "webm",
          "pdf",
          "icns",
        },
        doc = {
          -- enable image viewer for documents
          -- a treesitter parser must be available for the enabled languages.
          enabled = true,
          -- render the image inline in the buffer
          -- if your env doesn't support unicode placeholders, this will be disabled
          -- takes precedence over `opts.float` on supported terminals
          inline = true,
          -- render the image in a floating window
          -- only used if `opts.inline` is disabled
          float = true,
          max_width = 80,
          max_height = 40,
          -- Set to `true`, to conceal the image text when rendering inline.
          -- (experimental)
          ---@param lang string tree-sitter language
          ---@param type snacks.image.Type image type
          conceal = function(lang, type)
            -- only conceal math expressions
            return type == "math"
          end,
        },
        img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
        -- window options applied to windows displaying image buffers
        -- an image buffer is a buffer with `filetype=image`
        wo = {
          wrap = false,
          number = false,
          relativenumber = false,
          cursorcolumn = false,
          signcolumn = "no",
          foldcolumn = "0",
          list = false,
          spell = false,
          statuscolumn = "",
        },
        cache = vim.fn.stdpath("cache") .. "/snacks/image",
        -- icons used to show where an inline image is located that is
        -- rendered below the text.
        icons = {
          math = "󰪚 ",
          chart = "󰄧 ",
          image = " ",
        },
      },
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
        height = 0.90, -- Window height as fraction of screen
        prompt_position = "top", -- top | bottom
        preview_position = "right", -- or 'left', 'right', 'top', 'bottom'
      },
    },
  },
}
