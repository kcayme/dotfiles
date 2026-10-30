-- VSCode-style unified picker modes keyed by query prefix ("" = files); `title`/`prompt` unset fall back to defaults, extra keys go to the source, `enabled = false` turns a prefix off

local M = {}

M.mode_map = {
  [""] = {
    source = "files",
    title = "Files",
    prompt = " 󰈔 ",
    enabled = true,
    backend = require("core.config.pickers.fff").files,
  },
  ["@"] = {
    source = "lsp_symbols",
    title = "Symbols",
    prompt = " 󰊕 ",
    enabled = true,
  }, -- current file
  ["#"] = {
    source = "lsp_workspace_symbols",
    title = "Workspace Symbols",
    prompt = " 󰅩 ",
    enabled = true,
  },
  ["%"] = {
    source = "grep",
    title = "Grep",
    prompt = "  ",
    enabled = true,
    backend = require("core.config.pickers.fff").grep,
  },
  [":"] = {
    source = "line",
    title = "Go to Line",
    prompt = " 󰉻 ",
    enabled = true,
    backend = require("core.config.pickers.snacks").line_source,
  },
  [">"] = {
    source = "commands",
    title = "Commands",
    prompt = "  ",
    enabled = true,
  },
}

local function resolve_mode_by_prefix(prefix)
  local mode = M.mode_map[prefix]

  if not mode then
    return nil
  end

  local source = mode.backend or { source = mode.source, title = prefix .. " " .. mode.source }

  return {
    title = mode.title,
    prompt = mode.prompt,
    source = source,
  }
end

local function resolve_prefix_by_source(source)
  for k, v in pairs(M.mode_map) do
    if v.source == source and v.enabled ~= false then
      return k
    end
  end

  return nil
end

-- resolved snacks config per mode (finder/format/preview/confirm + user overrides)

local function init_configs()
  local picker_configs = {}
  local snacks_cfg = require("snacks.picker.config")

  for prefix, v in pairs(M.mode_map) do
    local mode = resolve_mode_by_prefix(prefix)
    local opts = vim.deepcopy(v)

    opts.backend, opts.source, opts.title, opts.prompt, opts.enabled = nil, nil, nil, nil, nil
    -- tree rendering needs picker-level opts the unified picker doesn't have
    opts.tree = false

    local merged_cfg = snacks_cfg.get(vim.tbl_deep_extend("force", mode.source, opts))

    picker_configs[prefix] = merged_cfg
  end

  return picker_configs
end

local picker_configs = init_configs()

function M.unified(opts)
  local config = require("snacks.picker.config")
  local current_prefix = resolve_prefix_by_source(opts.source) or ""
  local current_mode = resolve_mode_by_prefix(current_prefix)
  local found_mode = nil ---@type string?
  local default_prompt = current_mode.prompt

  Snacks.picker({
    title = opts.title or current_mode.title,
    live = opts.live_empty or true,
    show_empty = opts.show_empty or true,
    formatters = { file = { filename_first = true } },
    filter = {
      transform = function(picker, filter)
        filter.meta.mode = current_prefix

        local mode = resolve_mode_by_prefix(current_prefix)

        local cfg = picker_configs[current_prefix]
        if not cfg.live then
          -- non-live sources load once per mode and fuzzy-filter on `pattern`
          filter.search, filter.pattern = "", filter.search
        end

        -- every find, so function titles stay current
        picker.title = mode.title
        -- snacks draws the prompt in a statuscolumn without escaping `%`, so double it here
        local prompt = (mode.prompt or default_prompt) .. (current_prefix ~= "" and current_prefix .. " " or "")

        picker.opts.prompt = prompt:gsub("%%", "%%%%")

        if current_prefix ~= found_mode then
          found_mode = current_prefix
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
          local mode = resolve_mode_by_prefix(text:sub(1, 1))

          -- only switch from file mode when detected prefix is an enabled mode
          if current_prefix ~= "" or text == "" or not mode or mode.enabled == false then
            return
          end

          current_prefix = text:sub(1, 1)
          picker.input:set(nil, text:sub(2))
          picker:find()
        end,
      })
    end,

    finder = function(_, ctx)
      local meta = ctx.filter.meta
      local cfg = picker_configs[meta.mode]
      return config.finder(cfg.finder)(cfg, ctx)
    end,

    -- tag items so format/preview/confirm follow the mode that produced them
    transform = function(item, ctx)
      local meta = ctx.filter.meta
      item.mode = meta.mode
    end,

    format = function(item, picker)
      return config.format(picker_configs[item.mode])(item, picker)
    end,

    preview = function(ctx)
      return config.preview(picker_configs[ctx.item.mode])(ctx)
    end,

    confirm = function(picker, item, action)
      return Snacks.picker.actions[picker_configs[item.mode].confirm or "jump"](picker, item, action)
    end,

    on_close = picker_configs[""].on_close,
    actions = {
      unified_back = function(picker)
        if current_prefix == "" or picker.input:get() ~= "" then
          return vim.api.nvim_feedkeys(vim.keycode("<BS>"), "in", false)
        end

        current_prefix = ""
        picker:find()
      end,
    },
    win = { input = { keys = { ["<BS>"] = { "unified_back", mode = "i" } } } },
  })
end

return M
