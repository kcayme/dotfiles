local colors = require("utils.colors").get_base30_palette()

if colors then
  -- apply nvchad base46
  for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
    dofile(vim.g.base46_cache .. v)
  end

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
    -- customize flash.nvim hl
    {
      name = "FlashLabel",
      opts = {
        bg = colors and colors.black,
        fg = colors and colors.cyan,
        italic = true,
        bold = true,
      },
    },
    {
      name = "FlashMatch",
      opts = {
        bg = colors and colors.black,
        fg = colors and colors.sun,
        italic = true,
        bold = true,
      },
    },
    {
      name = "Search",
      opts = {
        fg = colors and colors.black,
        bg = colors and colors.cyan,
      },
    },
    {
      name = "CurSearch",
      opts = {
        fg = colors and colors.black,
        bg = colors and colors.sun,
        bold = true,
      },
    },
    {
      name = "BlinkCmpMenuBorder",
      opts = {
        link = "WinBar",
      },
    },
    {
      name = "LazyGitBorder",
      opts = {
        link = "FloatBorder",
      },
    },
    {
      name = "LazyGitFloat",
      opts = {
        link = "NormalFloat",
      },
    },
    -- vim-go highlight overrides
    {
      name = "goParamName",
      opts = {
        link = "@variable.parameter",
      },
    },
    {
      name = "goParamType",
      opts = {
        link = "Type",
      },
    },
    {
      name = "goPackage",
      opts = {
        link = "Function",
      },
    },
    {
      name = "goParen",
      opts = {
        link = "@variable.parameter",
      },
    },
    {
      name = "goSimpleParams",
      opts = {
        link = "SpecialChar",
      },
    },
    {
      name = "goSingleDecl",
      opts = {
        link = "SpecialChar",
      },
    },
    {
      name = "goCharacter",
      opts = {
        link = "String",
      },
    },

    {
      name = "goVarArgs",
      opts = {
        link = "SpecialChar",
      },
    },
    {
      name = "goFunctionReturn",
      opts = {
        link = "Type",
      },
    },
    {
      name = "goReceiver",
      opts = {
        link = "SpecialChar",
      },
    },
    {
      name = "goFunctionCall",
      opts = {
        link = "Function",
      },
    },
    -- {
    --   name = "goBlock",
    --   opts = {
    --     link = "SpecialChar",
    --   },
    -- },

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
end
