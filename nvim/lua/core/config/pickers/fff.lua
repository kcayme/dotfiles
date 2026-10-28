local M = {}

-- fff is required inside functions, not here: a top-level require would
-- force-load the plugin at startup and defeat its lazy-loading (see pickers.lua).

-- Snacks as ui with fff and backend
-- (https://github.com/madmaxieee/nvim-config/blob/c773485d76cf1fff4be3eca888a6ed4525cc9065/lua/plugins/fuzzy-finder/snacks-picker/fff.lua)

---@class FFFSnacksState
---@field current_file_cache? string
---@field config table FFF config

---@type FFFSnacksState
M.state = { config = {} }

local staged_status = {
  staged_new = true,
  staged_modified = true,
  staged_deleted = true,
  renamed = true,
}

local status_map = {
  untracked = "untracked",
  modified = "modified",
  deleted = "deleted",
  renamed = "renamed",
  staged_new = "added",
  staged_modified = "modified",
  staged_deleted = "deleted",
  ignored = "ignored",
  -- clean = "",
  -- clear = "",
  unknown = "untracked",
}

--- tweaked version of `Snacks.picker.format.file_git_status`
--- @type snacks.picker.format
local function format_file_git_status(item, picker)
  local ret = {} ---@type snacks.picker.Highlight[]
  local status = item.status

  local hl = "SnacksPickerGitStatus"
  if status.unmerged then
    hl = "SnacksPickerGitStatusUnmerged"
  elseif status.staged then
    hl = "SnacksPickerGitStatusStaged"
  else
    hl = "SnacksPickerGitStatus" .. status.status:sub(1, 1):upper() .. status.status:sub(2)
  end

  local icon = picker.opts.icons.git[status.status]
  if status.staged then
    icon = picker.opts.icons.git.staged
  end

  local text_icon = status.status:sub(1, 1):upper()
  text_icon = status.status == "untracked" and "?" or status.status == "ignored" and "!" or text_icon

  ret[#ret + 1] = { icon, hl }
  ret[#ret + 1] = { " ", virtual = true }

  ret[#ret + 1] = {
    col = 0,
    virt_text = { { text_icon, hl }, { " " } },
    virt_text_pos = "right_align",
    hl_mode = "combine",
  }
  return ret
end

---@type snacks.picker.Config
M.source = {
  title = "FFFiles",
  finder = function(opts, ctx)
    local conf = require("fff.conf")
    local file_picker = require("fff.file_picker")
    -- initialization code from require('fff.picker_ui').open
    -- on_show does not seem to be called before finder
    if not M.state.current_file_cache then
      local current_buf = vim.api.nvim_get_current_buf()
      if current_buf and vim.api.nvim_buf_is_valid(current_buf) then
        local current_file = vim.api.nvim_buf_get_name(current_buf)
        if current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
          M.state.current_file_cache = current_file
        else
          M.state.current_file_cache = nil
        end
      end
    end
    if not file_picker.is_initialized() then
      if not file_picker.setup() then
        vim.notify("Failed to initialize file picker", vim.log.levels.ERROR)
        return {}
      end
    end
    -- the first open races fff's initial scan; re-run until the index is ready (like fff's own UI)
    if not file_picker.get_scan_progress().is_index_ready then
      vim.defer_fn(function()
        ctx.picker:find()
      end, 100)
    end
    local config = conf.get()
    M.state.config = vim.tbl_deep_extend("force", config or {}, opts or {})

    local fff_result = file_picker.search_files(
      ctx.filter.search,
      M.state.current_file_cache,
      opts.limit or M.state.config.max_results,
      M.state.config.max_threads
    )

    ---@type snacks.picker.finder.Item[]
    local items = {}
    for _, fff_item in ipairs(fff_result) do
      ---@type snacks.picker.finder.Item
      local item = {
        text = fff_item.name,
        -- fff items only carry `relative_path` (to fff's base_path); resolve it the way fff's UI does
        file = require("fff.utils").canonicalize_fff_path(fff_item.relative_path),
        score = fff_item.total_frecency_score,
        -- HACK: in original snacks implementation status is a string of
        -- `git status --porcelain` output
        status = status_map[fff_item.git_status] and {
          status = status_map[fff_item.git_status],
          staged = staged_status[fff_item.git_status] or false,
          unmerged = fff_item.git_status == "unmerged",
        },
      }
      items[#items + 1] = item
    end

    return items
  end,
  format = function(item, picker)
    ---@type snacks.picker.Highlight[]
    local ret = {}

    if item.label then
      ret[#ret + 1] = { item.label, "SnacksPickerLabel" }
      ret[#ret + 1] = { " ", virtual = true }
    end

    if item.status then
      vim.list_extend(ret, format_file_git_status(item, picker))
    else
      ret[#ret + 1] = { "  ", virtual = true }
    end

    vim.list_extend(ret, require("snacks").picker.format.filename(item, picker))

    if item.line then
      require("snacks").picker.highlight.format(item, item.line, ret)
      table.insert(ret, { " " })
    end
    return ret
  end,
  on_close = function()
    M.state.current_file_cache = nil
  end,
  formatters = {
    file = {
      filename_first = true,
    },
  },
  live = true,
  show_empty = true,
}

-- local staged_status = {
--   staged_new = true,
--   staged_modified = true,
--   staged_deleted = true,
--   renamed = true,
-- }
--
-- local status_map = {
--   untracked = "untracked",
--   modified = "modified",
--   deleted = "deleted",
--   renamed = "renamed",
--   staged_new = "added",
--   staged_modified = "modified",
--   staged_deleted = "deleted",
--   ignored = "ignored",
--   -- clean = "",
--   -- clear = "",
--   unknown = "untracked",
-- }
--
-- ---@class FFFState
-- ---@field current_file_cache? string
-- M.state = {}
--
-- ---@type snacks.picker.finder
-- ---@diagnostic disable-next-line: unused-local
-- local function finder(opts, ctx)
--   local file_picker = require("fff.file_picker")
--
--   if not M.state.current_file_cache then
--     local current_buf = vim.api.nvim_get_current_buf()
--     if current_buf and vim.api.nvim_buf_is_valid(current_buf) then
--       local current_file = vim.api.nvim_buf_get_name(current_buf)
--       if current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
--         M.state.current_file_cache = current_file
--       else
--         M.state.current_file_cache = nil
--       end
--     end
--   end
--
--   local fff_result = file_picker.search_files(ctx.filter.search, 100, 4, M.state.current_file_cache, false)
--
--   ---@type snacks.picker.finder.Item[]
--   local items = {}
--   for _, fff_item in ipairs(fff_result) do
--     ---@type snacks.picker.finder.Item
--     local item = {
--       text = fff_item.name,
--       file = fff_item.path,
--       score = fff_item.total_frecency_score,
--       status = status_map[fff_item.git_status] and {
--         status = status_map[fff_item.git_status],
--         staged = staged_status[fff_item.git_status] or false,
--         unmerged = fff_item.git_status == "unmerged",
--       },
--     }
--     items[#items + 1] = item
--   end
--
--   return items
-- end
--
-- local function on_close()
--   M.state.current_file_cache = nil
-- end
--
-- local function format_file_git_status(item, picker)
--   local ret = {} ---@type snacks.picker.Highlight[]
--   local status = item.status
--
--   local hl = "SnacksPickerGitStatus"
--   if status.unmerged then
--     hl = "SnacksPickerGitStatusUnmerged"
--   elseif status.staged then
--     hl = "SnacksPickerGitStatusStaged"
--   else
--     hl = "SnacksPickerGitStatus" .. status.status:sub(1, 1):upper() .. status.status:sub(2)
--   end
--
--   local icon = picker.opts.icons.git[status.status]
--   if status.staged then
--     icon = picker.opts.icons.git.staged
--   end
--
--   local text_icon = status.status:sub(1, 1):upper()
--   text_icon = status.status == "untracked" and "?" or status.status == "ignored" and "!" or text_icon
--
--   ret[#ret + 1] = { icon, hl }
--   ret[#ret + 1] = { " ", virtual = true }
--
--   ret[#ret + 1] = {
--     col = 0,
--     virt_text = { { text_icon, hl }, { " " } },
--     virt_text_pos = "right_align",
--     hl_mode = "combine",
--   }
--   return ret
-- end
--
-- local function format(item, picker)
--   ---@type snacks.picker.Highlight[]
--   local ret = {}
--
--   if item.label then
--     ret[#ret + 1] = { item.label, "SnacksPickerLabel" }
--     ret[#ret + 1] = { " ", virtual = true }
--   end
--
--   if item.status then
--     vim.list_extend(ret, format_file_git_status(item, picker))
--   else
--     ret[#ret + 1] = { "  ", virtual = true }
--   end
--
--   vim.list_extend(ret, require("snacks.picker.format").filename(item, picker))
--
--   if item.line then
--     Snacks.picker.highlight.format(item, item.line, ret)
--     table.insert(ret, { " " })
--   end
--   return ret
-- end
--
function M.fff()
  -- local file_picker = require("fff.file_picker")
  -- if not file_picker.is_initialized() then
  --   local setup_success = file_picker.setup()
  --   if not setup_success then
  --     vim.notify("Failed to initialize file picker", vim.log.levels.ERROR)
  --   end
  -- end
  -- Snacks.picker({
  --   title = "FFFiles",
  --   finder = finder,
  --   on_close = on_close,
  --   format = format,
  --   live = true,
  -- })
  if Snacks and pcall(require, "snacks.picker") then
    -- Users can call Snacks.picker.fff() after this
    Snacks.picker.sources.fff = M.source
  end
  if Snacks and pcall(require, "snacks.picker") then
    Snacks.picker(M.source)
  else
    vim.notify("fff-sncaks: Snacks is not loaded", vim.log.levels.ERROR)
  end
end

-- M.files = function(opts)
--   -- M.fff(opts) -- FIXME: snacks FE + fff BE currently not working
--   picker.find_files(opts)
-- end

-- M.smart = function(opts)
--   -- M.fff(opts) -- FIXME: snacks FE + fff BE currently not working
--   picker.find_files(opts)
-- end

-- fff live grep (in-memory index) as a snacks source
---@type snacks.picker.Config
M.grep_source = {
  live = true,
  format = "file",
  finder = function(opts, ctx)
    if ctx.filter.search == "" then
      return {}
    end
    local file_picker = require("fff.file_picker")
    if not file_picker.is_initialized() then
      file_picker.setup()
    end
    local grep = require("fff.picker_ui.grep_renderer")
    local cwd = require("fff.conf").get().base_path

    ---@type snacks.picker.finder.Item[]
    local items = {}
    local offset = 0
    -- fff pages by file; keep pulling pages up to the limit
    repeat
      local result = grep.search(ctx.filter.search, offset, 50)
      for _, m in ipairs(result.items) do
        local positions = {} ---@type number[]
        for _, range in ipairs(m.match_ranges or {}) do
          for i = range[1] + 1, range[2] do -- 0-based [start, end) -> 1-based
            positions[#positions + 1] = i
          end
        end
        items[#items + 1] = {
          text = m.relative_path .. ":" .. m.line_content,
          file = m.relative_path,
          cwd = cwd,
          pos = { m.line_number, m.col },
          line = m.line_content,
          positions = positions,
        }
      end
      offset = result.next_file_offset
    until offset == 0 or #items >= (opts.limit or 1000)
    return items
  end,
}

-- wrapper, not a captured reference, so fff loads lazily on first call
function M.smart(opts)
  return require("fff").find_files(opts)
end

-- custom sources the unified picker can name with `backend = "fff"`
M.sources = { files = M.source, grep = M.grep_source }

return M
