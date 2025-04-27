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

      -- local tree_cb = require("nvim-tree.config.nvim_tree_callback")

      require("nvim-tree").setup({
        on_attach = my_on_attach,
        view = {
          width = 45,
          side = "right",
          relativenumber = true,
          preserve_window_proportions = true,
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
        renderer = {
          hidden_display = "all",
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
