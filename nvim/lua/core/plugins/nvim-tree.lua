return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        function _G.ToggleNvimTreeExpandCollapse()
          if _G.NvimTreeExpanded then
            api.tree.collapse_all()
            _G.NvimTreeExpanded = false
          else
            api.tree.expand_all()
            _G.NvimTreeExpanded = true
          end
        end

        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        -- vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "<ESC>", function()
          require("notify").dismiss()
        end, opts("Close"))
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
        vim.keymap.set("n", "<C-e>", api.tree.close, opts("Close Tree"))
        vim.keymap.set("n", "<C-[>", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts("CD"))
        vim.keymap.set("n", "L", api.node.open.vertical, opts("Open:Vertical Split"))
        vim.keymap.set("n", "E", ToggleNvimTreeExpandCollapse, opts("Toggle Expand/Collapse All"))
      end

      local function open_win_config_func()
        local screen = require("utils.screen")
        local scr_w = screen.screen_width
        local scr_h = screen.screen_height
        local tree_w = 45
        -- local tree_h = math.floor(tree_w * scr_h / scr_w)
        local tree_h = scr_h - 4
        return {
          border = "rounded",
          relative = "editor",
          width = tree_w,
          height = tree_h,
          -- col = (scr_w - tree_w) / 2,
          col = (scr_w - tree_w),
          -- row = (scr_h - tree_h) / 2,
          row = 1,
        }
      end

      require("nvim-tree").setup({
        on_attach = my_on_attach,
        view = {
          -- width = 45,
          -- side = "right",
          signcolumn = "yes",
          relativenumber = true,
          preserve_window_proportions = true,
          float = {
            enable = true,
            quit_on_focus_loss = true,
            open_win_config = open_win_config_func,
          },
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        renderer = {
          hidden_display = "all",
          indent_markers = {
            enable = true,
          },
          icons = {
            glyphs = {
              folder = {
                default = "",
                open = "",
                empty = "󰷏",
                empty_open = "󰷏",
                symlink = "",
                symlink_open = "",
              },
            },
          },
        },
        diagnostics = {
          enable = true,
        },
      })

      local map = vim.keymap.set
      local api = require("nvim-tree.api")
      map("n", "<C-e>", function()
        -- focus tree is visible but not focused; else, toggle tree
        if api.tree.is_visible() and not api.tree.is_tree_buf() then
          vim.cmd("NvimTreeFocus")
        else
          vim.cmd("NvimTreeFindFileToggle")
        end
        vim.cmd("NvimTreeRefresh")
      end, {})
    end,
  },
}
