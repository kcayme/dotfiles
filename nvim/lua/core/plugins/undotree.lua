return {
  "XXiaoA/atone.nvim",
  -- cmd = "Atone" ,
  opts = {
    layout = {
      width = 0.25,
    },
    diff_cur_node = {
      enabled = true,
      ---@type number float less than 1
      --- The diff window's height is set to a specified percentage of the original (namely tree graph) window's height.
      split_percent = 0.4,
    },
  },
  ui = {
    border = "rounded",
    compact = true,
  },
  keys = {
    { "<leader>u", "<cmd>Atone toggle<CR>", desc = "Toggle UndoTree" },
  },
}
