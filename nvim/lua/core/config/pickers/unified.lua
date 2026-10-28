-- VSCode-style unified picker modes keyed by query prefix ("" = files); `title`/`prompt` unset fall back to defaults, extra keys go to the source, `enabled = false` turns a prefix off

local M = {}
local snacks_src = require("core.config.pickers.snacks").sources
local fff_src = require("core.config.pickers.fff").sources

M.sources = vim.tbl_deep_extend("force", snacks_src, fff_src) or {}

M.modes = {
  [""] = {
    backend = "fff",
    source = "files",
    title = "Files",
    prompt = " 󰈔 ",
  },
  ["@"] = {
    backend = "snacks",
    source = "lsp_symbols",
    title = "Symbols",
    prompt = " 󰊕 ",
    enabled = true,
  }, -- current file
  ["#"] = {
    backend = "snacks",
    source = "lsp_workspace_symbols",
    title = "Workspace Symbols",
    prompt = " 󰅩 ",
    enabled = true,
  },
  ["%"] = {
    backend = "fff",
    source = "grep",
    title = "Grep",
    prompt = "  ",
    enabled = true,
  },
  [":"] = {
    backend = "snacks",
    source = "line",
    title = "Go to Line",
    prompt = " 󰉻 ",
    enabled = true,
  },
  [">"] = {
    backend = "snacks",
    source = "commands",
    title = "Commands",
    prompt = "  ",
    enabled = true,
  },
}

-- the backend's own source table, else a builtin snacks source
local function mode_source(prefix)
  local mode = M.modes[prefix]
  return M.sources[mode.source] or { source = mode.source, title = prefix .. " " .. mode.source }
end

local function mode_title(prefix)
  local title = M.modes[prefix].title
  return type(title) == "function" and title() or title
end

-- resolved snacks config per mode (finder/format/preview/confirm + user overrides)
local mode_configs = {}
local function mode_config(prefix)
  if not mode_configs[prefix] then
    local opts = vim.deepcopy(M.modes[prefix])
    opts.backend, opts.source, opts.title, opts.prompt, opts.enabled = nil, nil, nil, nil, nil
    -- tree rendering needs picker-level opts the unified picker doesn't have
    opts.tree = false
    mode_configs[prefix] = require("snacks.picker.config").get(vim.tbl_deep_extend("force", mode_source(prefix), opts))
  end
  return mode_configs[prefix]
end

function M.unified()
  local config = require("snacks.picker.config")
  local mode = "" -- current mode; its prefix lives in the prompt, not the input text
  local found_mode = nil ---@type string?
  local default_prompt = nil ---@type string?

  Snacks.picker({
    title = mode_title(""),
    live = true,
    show_empty = true,
    formatters = { file = { filename_first = true } },
    filter = {
      transform = function(picker, filter)
        filter.mode = mode

        local cfg = mode_config(mode)
        if not cfg.live then
          -- non-live sources load once per mode and fuzzy-filter on `pattern`
          filter.search, filter.pattern = "", filter.search
        end
        -- every find, so function titles stay current
        picker.title = mode_title(mode)

        default_prompt = default_prompt or picker.opts.prompt
        -- snacks draws the prompt in a statuscolumn without escaping `%`, so double it here
        local prompt = (M.modes[mode].prompt or default_prompt) .. (mode ~= "" and mode .. " " or "")

        picker.opts.prompt = prompt:gsub("%%", "%%%%")

        if mode ~= found_mode then
          found_mode = mode
          return true -- force the finder to re-run even if the query is unchanged
        end
      end,
    },
    on_show = function(picker)
      -- a prefix typed first in files mode moves from the input into the prompt
      vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = picker.input.win.buf,
        callback = function()
          local text = picker.input:get()
          local m = M.modes[text:sub(1, 1)]
          if mode ~= "" or text == "" or not m or m.enabled == false then
            return
          end
          mode = text:sub(1, 1)
          picker.input:set(nil, text:sub(2))
          picker:find()
        end,
      })
    end,
    finder = function(_, ctx)
      local cfg = mode_config(ctx.filter.mode)
      return config.finder(cfg.finder)(cfg, ctx)
    end,
    -- tag items so format/preview/confirm follow the mode that produced them
    transform = function(item, ctx)
      item.mode = ctx.filter.mode
    end,
    format = function(item, picker)
      return config.format(mode_config(item.mode))(item, picker)
    end,
    preview = function(ctx)
      return config.preview(mode_config(ctx.item.mode))(ctx)
    end,
    confirm = function(picker, item, action)
      return Snacks.picker.actions[mode_config(item.mode).confirm or "jump"](picker, item, action)
    end,
    on_close = mode_config("").on_close,
    actions = {
      unified_back = function(picker)
        if mode == "" or picker.input:get() ~= "" then
          return vim.api.nvim_feedkeys(vim.keycode("<BS>"), "in", false)
        end
        mode = ""
        picker:find()
      end,
    },
    win = { input = { keys = { ["<BS>"] = { "unified_back", mode = "i" } } } },
  })
end

return M
