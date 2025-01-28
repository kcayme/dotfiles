return {
  --   { -- Fuzzy er (files, lsp, etc)
  --     "nvim-telescope/telescope.nvim",
  --     event = "VimEnter",
  --     branch = "0.1.x",
  --     dependencies = {
  --       "nvim-lua/plenary.nvim",
  --       { -- If encountering errors, see telescope-fzf-native README for install instructions
  --         "nvim-telescope/telescope-fzf-native.nvim",
  --
  --         -- `build` is used to run some command when the plugin is installed/updated.
  --         -- This is only run then, not every time Neovim starts up.
  --         build = "make",
  --
  --         -- `cond` is a condition used to determine whether this plugin should be
  --         -- installed and loaded.
  --         cond = function()
  --           return vim.fn.executable("make") == 1
  --         end,
  --       },
  --       { "nvim-telescope/telescope-ui-select.nvim" },
  --
  --       -- Useful for getting pretty icons, but requires a Nerd Font.
  --       { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  --     },
  --     opts = {
  --       defaults = {
  --         sorting_strategy = "ascending",
  --         layout_strategy = "flex",
  --         layout_config = {
  --           horizontal = { preview_cutoff = 80, preview_width = 0.55 },
  --           vertical = { mirror = true, preview_cutoff = 25 },
  --           prompt_position = "top",
  --           width = 0.87,
  --           height = 0.80,
  --         },
  --       },
  --     },
  --     config = function()
  --       local actions = require("telescope.actions")
  --       require("telescope").setup({
  --         defaults = {
  --           mappings = {
  --             i = {
  --               ["<C-j>"] = actions.move_selection_next,
  --               ["<C-k>"] = actions.move_selection_previous,
  --             },
  --           },
  --         },
  --         pickers = {
  --           find_files = { hidden = true },
  --         },
  --         extensions = {
  --           ["ui-select"] = {
  --             require("telescope.themes").get_dropdown(),
  --           },
  --         },
  --       })
  --
  --       -- Enable telescope extensions, if they are installed
  --       pcall(require("telescope").load_extension, "fzf")
  --       pcall(require("telescope").load_extension, "ui-select")
  --
  --       -- See `:help telescope.builtin`
  --       local builtin = require("telescope.builtin")
  --       vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
  --       vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
  --       vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
  --       vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[F]ind [S]elect Telescope" })
  --       vim.keymap.set({ "n", "v" }, "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
  --       vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
  --       vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
  --       vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
  --       vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
  --       vim.keymap.set("n", "<leader>fb", function()
  --         builtin.buffers({ sort_lastused = true })
  --       end, { desc = "[F]ind  existing buffers" })
  --
  --       -- Slightly advanced example of overriding default behavior and theme
  --       vim.keymap.set("n", "<leader>f/", function()
  --         -- You can pass additional configuration to telescope to change theme, layout, etc.
  --         builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
  --           winblend = 2,
  --           previewer = true,
  --         }))
  --       end, { desc = "[F]uzzily search [/] in current buffer" })
  --
  --       -- Also possible to pass additional configuration options.
  --       --  See `:help telescope.builtin.live_grep()` for information about particular keys
  --       vim.keymap.set("n", "<leader>s/", function()
  --         builtin.live_grep({
  --           grep_open_files = true,
  --           prompt_title = "Live Grep in Open Files",
  --         })
  --       end, { desc = "[S]earch [/] in Open Files" })
  --
  --       -- Shortcut for searching your neovim configuration files
  --       vim.keymap.set("n", "<leader>fn", function()
  --         builtin.find_files({ cwd = vim.fn.stdpath("config") })
  --       end, { desc = "[S]earch [N]eovim files" })
  --     end,
  --   },
  --
  --   {
  --     "nvim-telescope/telescope-ui-select.nvim",
  --     config = function()
  --       -- To get ui-select loaded and working with telescope, you need to call
  --       -- load_extension, somewhere after setup function:
  --       require("telescope").load_extension("ui-select")
  --     end,
  --   },
  --   {
  --     "nvim-telescope/telescope-media-files.nvim",
  --     config = function()
  --       require("telescope").setup({
  --         extensions = {
  --           media_files = {
  --             -- filetypes whitelist
  --             -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
  --             filetypes = { "png", "jpg", "mp4", "webm", "pdf" },
  --             -- find command (defaults to `fd`)
  --             find_cmd = "rg",
  --           },
  --         },
  --       })
  --       require("telescope").load_extension("media_files")
  --     end,
  --   },
  --   {
  --     "danielfalk/smart-open.nvim",
  --     branch = "0.2.x",
  --     config = function()
  --       require("telescope").load_extension("smart_open")
  --       vim.keymap.set("n", "<leader><leader>", function()
  --         require("telescope").extensions.smart_open.smart_open()
  --       end, { noremap = true, silent = true })
  --     end,
  --     dependencies = {
  --       "kkharji/sqlite.lua",
  --       -- Only required if using match_algorithm fzf
  --       { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  --       -- Optional.  If installed, native fzy will be used when match_algorithm is fzy
  --       { "nvim-telescope/telescope-fzy-native.nvim" },
  --     },
  --   },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      -- "nvim-treesitter/nvim-treesitter-context",
    },
    opts = {
      keymap = {
        -- Below are the default binds, setting any value in these tables will override
        -- the defaults, to inherit from the defaults change [1] from `false` to `true`
        builtin = {
          -- neovim `:tmap` mappings for the fzf win
          -- true,        -- uncomment to inherit all the below in your custom config
          ["<M-Esc>"] = "hide", -- hide fzf-lua, `:FzfLua resume` to continue
          ["<F1>"] = "toggle-help",
          ["<F2>"] = "toggle-fullscreen",
          -- Only valid with the 'builtin' previewer
          ["<F3>"] = "toggle-preview-wrap",
          ["<F4>"] = "toggle-preview",
          -- Rotate preview clockwise/counter-clockwise
          ["<F5>"] = "toggle-preview-ccw",
          ["<F6>"] = "toggle-preview-cw",
          -- `ts-ctx` binds require `nvim-treesitter-context`
          ["<F7>"] = "toggle-preview-ts-ctx",
          ["<F8>"] = "preview-ts-ctx-dec",
          ["<F9>"] = "preview-ts-ctx-inc",
          ["<S-Left>"] = "preview-reset",
          ["<S-down>"] = "preview-page-down",
          ["<S-up>"] = "preview-page-up",
          ["<M-S-down>"] = "preview-down",
          ["<M-S-up>"] = "preview-up",
        },
        fzf = {
          -- fzf '--bind=' options
          -- true,        -- uncomment to inherit all the below in your custom config
          ["ctrl-z"] = "abort",
          ["ctrl-u"] = "unix-line-discard",
          ["ctrl-f"] = "half-page-down",
          ["ctrl-b"] = "half-page-up",
          ["ctrl-a"] = "beginning-of-line",
          ["ctrl-e"] = "end-of-line",
          ["alt-a"] = "toggle-all",
          ["alt-g"] = "first",
          ["alt-G"] = "last",
          -- Only valid with fzf previewers (bat/cat/git/etc)
          ["f3"] = "toggle-preview-wrap",
          ["f4"] = "toggle-preview",
          ["shift-down"] = "preview-page-down",
          ["shift-up"] = "preview-page-up",
        },
      },
    },
    config = function()
      require("fzf-lua").setup({
        winopts = {
          preview = {
            layout = "flex",
            horizontal = "right:60%",
            vertical = "up:60%",
          },
        },
        fzf_opts = {
          ["--layout"] = "default",
        },
        files = {
          prompt = "Files❯ ",
          git_icons = true,
          cwd_prompt = false,
        },
        grep = {
          prompt = "Grep❯ ",
        },
        buffers = {
          prompt = "Buffers❯ ",
        },
        oldfiles = {
          prompt = "History❯ ",
          include_current_session = true,
        },
      })

      local map = vim.keymap.set
      local fzf = require("fzf-lua")
      map("n", "<leader>ff", fzf.files, { desc = "[F]ind [F]iles" })
      map("n", "<leader>fb", fzf.buffers, {})
      map("n", "<leader>fg", fzf.live_grep, { desc = "[F]ind by [G]rep" })
      map({ "n", "v" }, "<leader>fw", fzf.grep_cWORD, { desc = "[F]ind current [W]ORD by grep" })
      map("n", "<leader>fs", fzf.builtin, { desc = "[F]ind [S]elect builtin" })
      map("n", "<leader>fk", fzf.keymaps, { desc = "[F]ind [K]eymaps" })
      map("n", "<leader>fr", fzf.resume, { desc = "[F]ind [R]esume" })
      map("n", "<leader>fd", fzf.diagnostics_document, { desc = "[F]ind [D]iagnostics" })
      map("n", "<leader><leader>", fzf.oldfiles, { desc = "[F]ind [O]ld Files" })
      map("n", "<leader>fh", fzf.help_tags, { desc = "[F]ind [H]elp" })
    end,
  },
}
