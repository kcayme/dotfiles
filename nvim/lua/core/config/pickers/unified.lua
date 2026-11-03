-- VSCode-style unified picker modes keyed by query prefix ("" = files); `title`/`prompt` unset fall back to defaults, extra keys go to the source, `enabled = false` turns a prefix off
local M = {}
local notify = require("utils.notification").notify

M.mode_map = {
  [""] = {
    enabled = true,
    overrides = require("core.config.pickers.fff").files,
    type = "files",
    picker_config = {
      title = "Files",
      prompt = " 󰈔 ",
    },
  },
  ["@"] = {
    enabled = true,
    type = "lsp_document_symbols",
    picker_config = {
      title = "Symbols",
      prompt = " 󰊕 ",
      source = "lsp_symbols",
    },
  },
  ["#"] = {
    enabled = true,
    type = "lsp_workspace_symbols",
    picker_config = {
      title = "Workspace Symbols",
      prompt = " 󰅩 ",
      source = "lsp_workspace_symbols",
    },
  },
  ["%"] = {
    enabled = true,
    type = "grep",
    overrides = require("core.config.pickers.fff").grep,
    picker_config = {
      title = "Grep",
      prompt = "  ",
    },
  },
  [":"] = {
    enabled = true,
    type = "line",
    overrides = require("core.config.pickers.snacks").line_source,
    picker_config = {
      title = "Go to Line",
      prompt = " 󰉻 ",
      source = "line",
    },
  },
  ["!"] = {
    enabled = true,
    type = "gitignored",
    overrides = require("core.config.pickers.snacks").gitignored,
    picker_config = {
      title = "Gitgnored Files",
      prompt = " 󰈉 ",
      source = "gitignored",
    },
  },
  [">"] = {
    enabled = true,
    type = "commands",
    picker_config = {
      title = "Commands",
      prompt = "  ",
      source = "commands",
    },
  },
}

local function resolve_prefix_by_type(type)
  for k, v in pairs(M.mode_map) do
    if v.type == type and v.enabled ~= false then
      return k
    end
  end

  return nil
end

-- merged per mode picker overrides to snacks picker config defaults  (finder/format/preview/confirm + user overrides)
local function merge_picker_configs()
  local snacks_cfg = require("snacks.picker.config")

  for prefix, mode in pairs(M.mode_map) do
    local opts = vim.tbl_deep_extend("force", mode.opts or {}, { tree = false })
    local custom_cfg = mode.overrides or {}
    local merged_cfg = snacks_cfg.get(vim.tbl_deep_extend("force", mode.picker_config, custom_cfg, opts))

    M.mode_map[prefix].picker_config = merged_cfg
  end
end

local ok, err = pcall(merge_picker_configs)
if not ok then
  notify("[Unified] failed to init configs: " .. tostring(err), vim.log.levels.ERROR)
end

function M.unified(opts)
  local config = require("snacks.picker.config")
  local current_prefix = resolve_prefix_by_type(opts.type) or ""
  local current_mode = M.mode_map[current_prefix]
  local found_mode = nil ---@type string?
  local default_prompt = current_mode.picker_config.prompt

  Snacks.picker({
    title = opts.title or current_mode.picker_config.title,
    live = opts.live_empty or true,
    show_empty = opts.show_empty or true,
    formatters = { file = { filename_first = true } },
    filter = {
      transform = function(picker, filter)
        filter.meta.mode = current_prefix

        local mode = M.mode_map[current_prefix]
        local picker_cfg = mode.picker_config

        if not picker_cfg.live then
          -- non-live sources load once per mode and fuzzy-filter on `pattern`
          filter.search, filter.pattern = "", filter.search
        end

        -- every find, so function titles stay current
        picker.title = picker_cfg.title
        -- snacks draws the prompt in a statuscolumn without escaping `%`, so double it here
        local prompt = (picker_cfg.prompt or default_prompt) .. (current_prefix ~= "" and current_prefix .. " " or "")

        picker.opts.prompt = prompt:gsub("%%", "%%%%")

        if current_prefix ~= found_mode then
          found_mode = current_prefix
          return true -- force the finder to re-run even if the query is unchanged
        end
      end,
    },

    on_show = function(picker)
      -- files mode's own on_show (fff resumes git status tracking there), paired with on_close below
      local picker_config = M.mode_map[""].picker_config
      if picker_config.on_show then
        picker_config.on_show(picker)
      end

      -- a prefix typed first in files mode moves from the input into the prompt
      vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = picker.input.win.buf,
        callback = function()
          local text = picker.input:get()
          local query = text:sub(1, 1)
          local mode = M.mode_map[query]

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

    on_close = M.mode_map[""].picker_config.on_close,

    finder = function(_, ctx)
      local meta = ctx.filter.meta
      local picker_config = M.mode_map[meta.mode].picker_config
      return config.finder(picker_config.finder)(picker_config, ctx)
    end,

    -- tag items so format/preview/confirm follow the mode that produced them
    transform = function(item, ctx)
      local meta = ctx.filter.meta
      item.mode = meta.mode
    end,

    format = function(item, picker)
      return config.format(M.mode_map[item.mode].picker_config)(item, picker)
    end,

    preview = function(ctx)
      return config.preview(M.mode_map[ctx.item.mode].picker_config)(ctx)
    end,

    confirm = function(picker, item, action)
      local cfg = M.mode_map[item.mode].picker_config
      return Snacks.picker.actions[cfg.confirm or "jump"](picker, item, action)
    end,

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
