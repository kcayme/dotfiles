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
    "esmuellert/vscode-diff.nvim",
    keys = {
      {
        "<leader>d",
        "<cmd>CodeDiff<cr>",
        desc = "Toggle Diff View",
      },
    },
    dependencies = { "MunifTanjim/nui.nvim" },
  },
}
