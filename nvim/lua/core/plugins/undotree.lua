return {
  "jiaoshijie/undotree",
  ---@module 'undotree.collector'
  ---@type UndoTreeCollector.Opts
  opts = {
    float_diff = true, -- using float window previews diff, set this `true` will disable layout option
    -- layout = "left_bottom", -- "left_left_bottom", "left_left_bottom"
    position = "left", -- "right", "bottom"
    window = {
      winblend = 30,
      border = "rounded", -- The string values are the same as those described in 'winborder'.
    },
  },
  keys = {
    { "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
  },
}
