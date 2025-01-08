return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
    render = "compact", -- default, compact, minimal, simple
    stages = "fade",
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      messages = {
        -- NOTE: If you enable messages, then the cmdline is enabled automatically.
        -- This is a current Neovim limitation.
        enabled = true, -- enables the Noice messages UI
        view = "notify", -- default view for messages
        view_error = "virtualtext", -- view for errors
        view_warn = "virtualtext", -- view for warnings
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
      lsp = {
        progress = { enabled = false },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      views = {
        cmdline_popup = {
          position = {
            row = 10,
            col = "50%",
          },
          size = {
            width = 70,
            height = "auto",
          },
        },
        popupmenu = {
          relative = "editor",
          position = "auto",
          -- {
          --   row = 17,
          --   col = "50%",
          -- },
          size = {
            width = 60,
            height = 15,
          },
          border = {
            style = "rounded",
            padding = { 1, 1 },
          },
          win_options = {
            winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          },
        },
      },
      routes = {
        {
          filter = {
            event = "notify",
            min_height = 10,
            max_width = 15,
          },
          view = "split",
        },
        -- disable lsp messages
        {
          filter = {
            event = "lsp",
            kind = "message",
          },
          opts = { skip = true },
        },
      },
    })

    local ok, notify = pcall(require, "notify")
    if not ok then
      return
    end

    notify.setup({
      timeout = 3000,
      render = "minimal",
      stages = "fade_in_slide_out",
      top_down = false,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { focusable = false })
      end,
    })

    require("telescope").load_extension("noice")
  end,
}
