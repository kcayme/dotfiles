-- apply nvchad base46
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

-- support undercurl on diagnostic highlights
-- local colors = require("base46").get_theme_tb("base_30")
--
-- local hl_color_map = {
--   {
--     group_name = "DiagnosticUnderlineError",
--     opts = { sp = colors.red },
--   },
--   {
--     group_name = "DiagnosticUnderlineWarn",
--     opts = { sp = colors.eared },
--   },
--   {
--     group_name = "DiagnosticUnderlineInfo",
--     opts = { sp = colors.red },
--   },
--   {
--     group_name = "DiagnosticUnderlineHint",
--     opts = { sp = colors.red },
--   },
--   {
--     group_name = "BlinkCmpGhostText",
--     opts = { fg = "#4e5665" },
--   },
-- }

-- for _, value in ipairs(hl_color_map) do
--   vim.api.nvim_set_hl(0, value.group_name, value.opts)
-- end
