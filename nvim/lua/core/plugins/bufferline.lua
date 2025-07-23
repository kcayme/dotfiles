return {
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      "folke/noice.nvim",
      "folke/snacks.nvim",
    },
    config = function()
      require("bufferline").setup({
        options = {
          themable = true,
          -- numbers = "both",
          numbers = function(opts)
            return string.format("%s %s", opts.ordinal, opts.raise(opts.id))
          end,
          always_show_bufferline = true,
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            -- local icon = level:match("error") and " " or " "
            -- return " " .. icon .. count
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or " ")
              s = s .. n .. sym
              if e == "error" then
                s = s .. count
              end
            end
            return s
          end,
          --separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          indicator = {
            icon = "▎", -- this should be omitted if indicator style is not 'icon'
            style = "icon",
          },
          pick = {
            alphabet = "1234567890abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMOPQRSTUVWXYZ",
          },
          close_command = function()
            Snacks.bufdelete()
          end,
          offsets = {
            {
              filetype = "NvimTree",
              -- text = "File Explorer",
              text_align = "left",
              text = function()
                return "Directory: " .. vim.fn.getcwd()
              end,
              separator = true, -- use a "true" to enable the default, or set your own character
            },
          },
        },
      })

      local map = vim.keymap.set
      -- map("n", ")", "<cmd>BufferLineMoveNext<cr>", {})
      -- map("n", "(", "<cmd>BufferLineMovePrev<cr>", {})
      map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", {})
      map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", {})
      -- map("n", "<leader>bx", "<cmd>Bdelete<cr>", {}) -- bufdelete.nvim command
      map("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick Close buffer" })
      map("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pick Close buffer" })
      map("n", "<leader>bC", function()
        Snacks.bufdelete.other()
      end, { desc = "Close other buffers" })
      map("n", "<leader>bs", "<cmd>BufferLinePick<cr>", {})

      -- close buffer if it is in bufferline; else, close window
      map({ "n" }, "<Leader>x", function()
        local noice = require("noice")
        local buffers = require("bufferline").get_elements().elements
        local currentBufferId = vim.api.nvim_get_current_buf()

        for _, buf in ipairs(buffers) do
          if buf.id == currentBufferId then
            noice.notify("Buffer closed")
            Snacks.bufdelete()
            return
          end
        end

        noice.notify("Window closed")
        vim.cmd("close")
      end, { desc = "Close vertical window split" })

      -- for i = 1, 5, 1 do
      --   map(
      --     "n",
      --     string.format("<leader>%d", i),
      --     string.format("<cmd>BufferLineGoToBuffer %d<cr>", i),
      --     { desc = "Pick buffer by visible position" }
      --   )
      -- end

      -- map("n", "<leader>w", function()
      --   local items = {}
      --   local longest_name = 0
      --   for i, workspace in ipairs(require("workspaces").get()) do
      --     table.insert(items, {
      --       idx = i,
      --       score = i,
      --       text = workspace.path,
      --       name = workspace.name,
      --     })
      --     longest_name = math.max(longest_name, #workspace.name)
      --   end
      --   longest_name = longest_name + 2
      --   return Snacks.picker({
      --     items = items,
      --     format = function(item)
      --       local ret = {}
      --       ret[#ret + 1] = { ("%-" .. longest_name .. "s"):format(item.name), "SnacksPickerLabel" }
      --       ret[#ret + 1] = { item.text, "SnacksPickerComment" }
      --       return ret
      --     end,
      --     confirm = function(picker, item)
      --       picker:close()
      --       vim.cmd(("WorkspacesOpen %s"):format(item.name))
      --     end,
      --   })
      -- end, {})
    end,
  },
}
