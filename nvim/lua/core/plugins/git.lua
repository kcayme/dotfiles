-- git-related plugins
return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      -- "LazyGitConfig",
      -- "LazyGitCurrentFile",
      -- "LazyGitFilter",
      -- "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "U" },
        },
        signs_staged = {
          add = { text = "┃" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "U" },
        },
        -- signs = {
        --   add = { text = "+" },
        --   change = { text = "~" },
        --   delete = { text = "_" },
        --   topdelete = { text = "‾" },
        --   changedelete = { text = "~" },
        --   untracked = { text = "U" },
        -- },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 200,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
      })

      local map = vim.keymap.set
      map("n", "<leader>bl", "<cmd>Gitsigns blame<cr>", { desc = "Git Blame" })
      map("n", "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", { desc = "Git Next Hunk" })
      map("n", "<leader>gN", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Git Prev Hunk" })
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  },
  {
    "ahkohd/difft.nvim",
    keys = {
      {
        "<leader>d",
        function()
          if Difft.is_visible() then
            Difft.hide()
          else
            Difft.diff()
          end
        end,
        desc = "Toggle Difft",
      },
    },
    config = function()
      require("difft").setup({
        command = "GIT_EXTERNAL_DIFF='difft --color=always' git diff",
        -- layout = "ivy_taller",
        layout = "float", -- nil (buffer), "float", or "ivy_taller"
        no_diff_message = "All clean! No changes detected.",
        loading_message = "Loading diff...",
        window = {
          number = true,
          relativenumber = false,
          border = "rounded",
        },
        header = {
          content = function(filename, step, _language)
            local devicons = require("nvim-web-devicons")
            local basename = vim.fn.fnamemodify(filename, ":t")
            local icon, hl = devicons.get_icon(basename)

            -- Get the bg from FloatTitle (what DifftFileHeader links to)
            local header_hl = vim.api.nvim_get_hl(0, { name = "FloatTitle", link = false })

            -- Create custom highlight with devicon fg + header bg
            local icon_hl = hl
            if hl and header_hl.bg then
              local devicon_colors = vim.api.nvim_get_hl(0, { name = hl })
              if devicon_colors.fg then
                local custom_hl_name = "DifftIcon_" .. hl
                vim.api.nvim_set_hl(0, custom_hl_name, {
                  fg = devicon_colors.fg,
                  bg = header_hl.bg,
                })
                icon_hl = custom_hl_name
              end
            end

            local result = {}
            table.insert(result, { " " })
            table.insert(result, { icon and (icon .. " ") or "", icon_hl })
            table.insert(result, { filename })
            table.insert(result, { " " })

            if step then
              table.insert(result, { "• " })
              table.insert(result, { tostring(step.current) })
              table.insert(result, { "/" })
              table.insert(result, { tostring(step.of) })
              table.insert(result, { " " })
            end

            return result
          end,
          highlight = {
            link = "FloatTitle",
            full_width = true,
          },
        },
      })
    end,
  },
}
