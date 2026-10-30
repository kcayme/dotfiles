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
      -- map("n", "<leader>bl", "<cmd>Gitsigns blame<cr>", { desc = "Git Blame" })
      map("n", "<leader>bl", function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "gitsigns-blame" then
            vim.api.nvim_win_close(win, true)
            return
          end
        end

        vim.cmd("Gitsigns blame")
      end, { desc = "Git Blame" })
      map("n", "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", { desc = "Git Next Hunk" })
      map("n", "<leader>gN", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Git Prev Hunk" })
    end,
  },
  {
    "esmuellert/codediff.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "folke/snacks.nvim" },
    cmd = "CodeDiff",
    keys = {
      {
        "<leader>d",
        function()
          local checkout_rank = {} -- branch -> position in reflog, lower = checked out more recently
          for i, line in ipairs(vim.fn.systemlist({ "git", "reflog", "--format=%gs" })) do
            local to = line:match("^checkout: moving from %S+ to (%S+)$")
            if to and not checkout_rank[to] then
              checkout_rank[to] = i
            end
          end

          Snacks.picker.git_branches({
            all = true,
            cmd_args = { "--sort=-committerdate" },
            title = "Branch to CodeDiff",
            transform = function(item)
              item.text = item.branch or item.commit -- match on branch name only, not the commit message
              item.is_local = not (item.branch or ""):find("^remotes/")
              item.checkout = checkout_rank[item.branch] or math.huge
            end,
            sort = { fields = { "current", "is_local", "score:desc", "checkout", "idx" } },
            matcher = { sort_empty = true }, -- apply sort before anything is typed
            preview = function(ctx)
              Snacks.picker.preview.cmd({
                "git",
                "--no-pager",
                "diff",
                "--color=always",
                "--stat=" .. vim.api.nvim_win_get_width(ctx.win),
                ctx.item.commit,
              }, ctx)
            end,
            confirm = function(picker, item)
              picker:close()
              if item and item.branch then
                vim.cmd("CodeDiff " .. item.branch)
              end
            end,
          })
        end,
        desc = "CodeDiff Against Branch",
      },
    },
    init = function()
      -- Scroll the modified pane from the explorer; scrollbind keeps the original pane in sync.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "codediff-explorer",
        callback = function(ev)
          local function scroll(key)
            return function()
              local _, win = require("codediff.ui.lifecycle").get_windows(vim.api.nvim_get_current_tabpage())
              if win and vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_call(win, function()
                  vim.cmd("normal! " .. vim.keycode(key))
                end)
              end
            end
          end
          vim.keymap.set("n", "<C-d>", scroll("<C-d>"), { buffer = ev.buf, desc = "Scroll diff down" })
          vim.keymap.set("n", "<C-u>", scroll("<C-u>"), { buffer = ev.buf, desc = "Scroll diff up" })
        end,
      })
    end,
    opts = {
      highlights = {
        -- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
        line_insert = "DiffAdd", -- Line-level insertions
        line_delete = "DiffDelete", -- Line-level deletions

        -- Character-level: accepts highlight group names or hex colors
        -- If specified, these override char_brightness calculation
        char_insert = nil, -- Character-level insertions (nil = auto-derive)
        char_delete = nil, -- Character-level deletions (nil = auto-derive)

        -- Brightness multiplier (only used when char_insert/char_delete are nil)
        -- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
        char_brightness = 1.5, -- Auto-adjust based on your colorscheme

        -- Conflict sign highlights (for merge conflict views)
        -- Accepts highlight group names or hex colors (e.g., "#f0883e")
        -- nil = use default fallback chain
        conflict_sign = nil, -- Unresolved: DiagnosticSignWarn -> #f0883e
        conflict_sign_resolved = nil, -- Resolved: Comment -> #6e7681
        conflict_sign_accepted = nil, -- Accepted: GitSignsAdd -> DiagnosticSignOk -> #3fb950
        conflict_sign_rejected = nil, -- Rejected: GitSignsDelete -> DiagnosticSignError -> #f85149
      },
      -- Diff view behavior
      diff = {
        layout = "side-by-side", -- Diff layout: "side-by-side" (two panes) or "inline" (single pane with virtual lines)
        filler_text = " ", -- Repeated filler pattern; use "" for blank alignment rows
        disable_inlay_hints = true, -- Disable inlay hints in diff windows for cleaner view
        max_computation_time_ms = 5000, -- Maximum time for diff computation (VSCode default)
        ignore_trim_whitespace = false, -- Ignore leading and trailing whitespace changes
        hide_merge_artifacts = false, -- Hide merge tool temp files (*.orig, *.BACKUP.*, *.BASE.*, *.LOCAL.*, *.REMOTE.*)
        original_position = "left", -- Position of original (old) content: "left" or "right"
        conflict_ours_position = "right", -- Position of ours (:2) in conflict view: "left" or "right"
        conflict_result_position = "bottom", -- "bottom" (default): result below diff panes or "center": result between diff panes (three columns)
        conflict_result_height = 30, -- Height of result pane in bottom layout (% of total height)
        conflict_result_width_ratio = { 1, 1, 1 }, -- Width ratio for center layout panes {left, center, right} (e.g., {1, 2, 1} for wider result)
        cycle_next_hunk = true, -- Wrap around when navigating hunks (]c/[c): false to stop at first/last
        cycle_next_file = true, -- Wrap around when navigating files (]f/[f): false to stop at first/last
        cycle_hunks_across_files = false, -- ]c/[c at file boundary hops to first/last hunk of next/prev file (explorer/history)
        jump_to_first_change = true, -- Auto-scroll to first change when opening a diff: false to stay at same line
        highlight_added_deleted_files = false, -- Tint full contents of added, untracked, and deleted files
        highlight_priority = 100, -- Priority for line-level diff highlights (increase to override LSP highlights)
        gutter_signs = {
          gutter_signs = {
            insert_text = "＋",
            delete_text = "－",
            highlight_numbers = true,
            changed_priority = 100,
            unchanged_priority = 7,
          },
        }, -- Gutter +/- signs; see Gutter signs below
        compute_moves = false, -- Detect moved code blocks (opt-in, matches VSCode experimental.showMoves)
        compact_context_lines = 3, -- Number of context lines around hunks in compact mode
        compact_sync_folds = true, -- Sync fold open/close across panes (mirrors Vim diff mode behavior)
        compact = true, -- Default compact preference for each CodeDiff session; toggle with gc
      },
      explorer = {
        position = "left", -- "left" or "bottom"
        hidden = false, -- Initial visibility state
        width = 30, -- Width when position is "left" (columns)
        height = 15, -- Height when position is "bottom" (lines)
        auto_refresh = true, -- Native file watching with polling fallback (R still refreshes manually)
        indent_markers = true, -- Show indent markers in tree view (│, ├, └)
        initial_focus = "explorer", -- Initial focus: "explorer", "original", or "modified"
        icons = {
          folder_closed = "\u{e5ff}", -- Nerd Font folder icon
          folder_open = "\u{e5fe}", -- Nerd Font open-folder icon
        },
        view_mode = "tree", -- "list" or "tree"
        flatten_dirs = true, -- Flatten single-child directory chains in tree view
        file_filter = {
          ignore = {
            ".git/**",
            ".jj/**",
          }, -- Glob patterns to hide (e.g., {"*.lock", "dist/*"})
        },
        untracked = "all", -- Untracked scan: "all", "normal" (collapse dirs), or "no" (skip; use for huge work trees like GIT_WORK_TREE=$HOME that hang, #389)
        focus_on_select = false, -- Jump to modified pane after selecting a file (default: stay in explorer)
        auto_open_on_cursor = true, -- Rebind j/k/Down/Up in the explorer to also open the file under the cursor
        status_right_margin = 1, -- Trailing cells between status symbol (M/A/D) and right edge; increase if Nerd Font icons clip it
        line_stats = {
          enabled = true, -- Fetch and show Git line statistics
          count_untracked = false, -- Count untracked file lines as insertions
          max_untracked_bytes = 1024 * 1024, -- Skip larger untracked files
        },
        ellipsis = "…", -- Text appended to truncated Explorer regions
        formatters = { -- Optional function(ctx) -> line layout callbacks; omit to use the built-ins
          file = nil, -- File rows
          folder = nil, -- Directory rows in tree view
          group = function(ctx)
            local right = { { segments = { { text = ctx.file_count .. " files", hl = "Number" } } } }
            -- Formatters only see their own group, so read sibling groups from the explorer tree.
            local view = require("codediff.ui.lifecycle").get_panel_view(vim.api.nvim_get_current_tabpage())
            local groups = view and view.tree and view.tree:get_nodes() or {}
            if ctx.stats and groups[1] and groups[1].data.name == ctx.name then
              local ins, del = 0, 0
              for _, node in ipairs(groups) do
                ins = ins + node.data.stats.insertions
                del = del + node.data.stats.deletions
              end
              table.insert(right, 1, {
                segments = {
                  -- { text = #groups > 1 and "Σ " or "", hl = "CodeDiffExplorerTreeGroup" },
                  { text = "+" .. ins, hl = "CodeDiffExplorerStatInsertions" },
                  { text = " -" .. del .. " ", hl = "CodeDiffExplorerStatDeletions" },
                },
              })
            end
            return {
              left = {
                {
                  segments = { { text = " " .. ctx.label, hl = "CodeDiffExplorerTreeGroup" } },
                  truncate_priority = 1,
                },
              },
              right = right,
            }
          end,
        },
        visible_groups = { -- Which groups to show (can be toggled at runtime)
          staged = true,
          unstaged = true,
          conflicts = true,
        },
      },
    },
  },
}
