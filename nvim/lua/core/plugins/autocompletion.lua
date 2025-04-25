return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          -- INFO: vscode snippets
          require("luasnip.loaders.from_vscode").lazy_load()
          -- INFO: custom snippets
          require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
        end,
      },
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
      },
      {
        "saghen/blink.compat",
        opts = {},
        version = "*",
        lazy = false,
      },
      { "onsails/lspkind.nvim" },
    },

    version = "*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- fallback
      keymap = {
        preset = "super-tab",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<Esc>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        -- ["<C-n>"] = { "snippet_forward", "fallback" },
        -- ["<C-p>"] = { "snippet_backward", "fallback" },
        -- ["<Up>"] = { "select_prev", "fallback" },
        -- ["<Down>"] = { "select_next", "fallback" },
      },

      completion = {
        list = { selection = { preselect = false, auto_insert = false } },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        ghost_text = { enabled = true, show_with_menu = false },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          auto_show = true,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon", gap = 1 },
              { "label", "label_description", "kind", gap = 1 },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local lspkind = require("lspkind")
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, {
                      mode = "symbol",
                    })
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
      },

      signature = { enabled = true },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },

      snippets = {
        preset = "luasnip",
        expand = function(args)
          return require("luasnip").lsp_expand(args)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end
          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },

      cmdline = {
        completion = { ghost_text = { enabled = true } },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            name = "lsp",
            enabled = true,
            module = "blink.cmp.sources.lsp",
            score_offset = 1000,
          },
          snippets = {
            name = "snippets",
            enabled = true,
            module = "blink.cmp.sources.snippets",
            score_offset = 900, -- the higher the number, the higher the priority
          },
          path = {
            name = "Path",
            module = "blink.cmp.sources.path",
            score_offset = 500,
            enabled = true,
            fallbacks = { "snippets", "buffer" },
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            name = "Buffer",
            enabled = true,
            max_items = 3,
            module = "blink.cmp.sources.buffer",
            score_offset = 600, -- the higher the number, the higher the priority
          },
          -- nvim_lsp = {
          --   name = "cmp_nvim_lsp",
          --   enabled = true,
          --   module = "blink.compat.source",
          --   score_offset = 950,
          -- },
          -- cmp_path = {
          --   name = "path",
          --   enabled = true,
          --   module = "blink.compat.source",
          -- },
        },
        -- cmdline = {},
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
