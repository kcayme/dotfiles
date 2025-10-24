-- apply nvchad base46
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

local colors = require("utils.colors").get_base30_palette()

local custom_hls = {
  {
    name = "RoundedEdgeActive",
    opts = { fg = colors and colors.blue or "#FFFFFF", bg = colors and colors.darker_black or "#000000" },
  },
  {
    name = "RoundedInnerActive",
    opts = {
      fg = colors and colors.darker_black or "#000000",
      bg = colors and colors.blue or "#ffffff",
      bold = false,
    },
  },
  {
    name = "RoundedEdgeInactive",
    opts = {
      fg = colors and colors.darker_black or "#000000",
      bg = colors and colors.darker_black or "None",
      bold = false,
    },
  },
  {
    name = "RoundedInnerInactive",
    opts = {
      fg = "#FFFFFF",
      bg = colors and colors.darker_black or "#000000",
      bold = false,
    },
  },
  {
    name = "RoundedInnerActiveSecondary",
    opts = {
      fg = colors and colors.darker_black or "#000000",
      bg = colors and colors.blue or "#ffffff",
      bold = false,
      italic = true,
    },
  },
  {
    name = "RoundedInnerInactiveSecondary",
    opts = {
      fg = colors and colors.white,
      bg = colors and colors.darker_black or "#000000",
      bold = false,
      italic = true,
    },
  },
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
}

for _, value in ipairs(custom_hls) do
  vim.api.nvim_set_hl(0, value.name, value.opts)
end
