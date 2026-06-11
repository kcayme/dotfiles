return {
  "XXiaoA/atone.nvim",
  -- cmd = "Atone" ,
  opts = {
    layout = {
      width = 0.35,
    },
    diff_cur_node = {
      enabled = true,
      ---@type number float less than 1
      --- The diff window's height is set to a specified percentage of the original (namely tree graph) window's height.
      split_percent = 0.5,
      -- width = 100,
    },
    diff_float = {
      width = 1,
      height = 0.9,
      autoclose = true,
    },
    ui = {
      border = "rounded",
      compact = true,
      node_label = {
        custom = true,
        formatter = function(ctx)
          local time = require("utils.time")

          return {
            "[",
            { ctx.seq, ctx.is_current and "AtoneCurrentNode" or "AtoneSeq" },
            "] ",
            { time.format_ago(os.time(), ctx.time), "Comment" },
            { ctx.bookmark or "", "AtoneMark" },
          }
        end,
      },
    },
  },
  keys = {
    { "<leader>u", "<cmd>Atone toggle<CR>", desc = "Toggle UndoTree" },
  },
}
