return {
  -- "gc" to comment visual regions/lines
  {
    "numToStr/Comment.nvim",
    opts = {},
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })

      local api = require("Comment.api")
      local map = vim.api.nvim_set_keymap
      map("n", "<C-/>", "gcc", { noremap = false, desc = "Toggle linewise comment" })
      map("v", "<C-/>", "gcc", { noremap = false, desc = "Toggle blockwise comment" })
      vim.keymap.set("x", "<leader><C-/>", function()
        vim.api.nvim_feedkeys(esc, "nx", false)
        api.toggle.blockwise(vim.fn.visualmode())
      end, { noremap = false, desc = "Toggle blockwise comment" })
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
      })

      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
  {
    "danymat/neogen",
    config = true,
  },
}
