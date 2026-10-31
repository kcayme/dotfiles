local M = {}
local notify = require("utils.notification").notify

-- fff git_status -> `git status --porcelain` XY code, the format snacks expects in item.status
-- ("clean" and conflicted files have no entry, so they get no status)
local git_porcelain = {
  untracked = "??",
  modified = " M",
  deleted = " D",
  renamed = " R",
  staged_new = "A ",
  staged_modified = "M ",
  staged_deleted = "D ",
  ignored = "!!",
  unknown = "??",
}

--- tweaked version of `Snacks.picker.format.file_git_status`: git icon on the left, status letter right-aligned
--- @type snacks.picker.format
local function format_git_status(item, picker)
  local status = require("snacks.picker.source.git").git_status(item.status)

  local hl = "SnacksPickerGitStatus"
  if status.unmerged then
    hl = "SnacksPickerGitStatusUnmerged"
  elseif status.staged then
    hl = "SnacksPickerGitStatusStaged"
  else
    hl = "SnacksPickerGitStatus" .. status.status:sub(1, 1):upper() .. status.status:sub(2)
  end

  -- staged files keep their type icon (added/modified/deleted); the Staged highlight marks them as staged
  local icon = picker.opts.icons.git[status.status]

  local text_icon = status.status:sub(1, 1):upper()
  text_icon = status.status == "untracked" and "?" or status.status == "ignored" and "!" or text_icon

  return {
    { icon, hl },
    { " ", virtual = true },
    {
      col = 0,
      virt_text = { { text_icon, hl }, { " " } },
      virt_text_pos = "right_align",
      hl_mode = "combine",
    },
  }
end

-- init fff engine
---@param ctx snacks.picker.finder.ctx
local function init_fff(ctx)
  local picker_engine = require("fff.file_picker")
  if not picker_engine.is_initialized() then
    if not picker_engine.setup() then
      notify("Failed to initialize file picker", vim.log.levels.ERROR)
      return nil
    end
  end

  -- the first open races fff's initial scan and git status refresh; re-run until both are done (like fff's own UI)
  if not picker_engine.get_scan_progress().is_index_ready or picker_engine.is_git_status_refreshing() then
    vim.defer_fn(function()
      ctx.picker:find()
    end, 100)
  end

  return picker_engine
end

-- transform results from fff into snack items
---@param fff_result table
---@return snacks.picker.finder.Item[]
local function to_snacks_items(fff_result)
  ---@type snacks.picker.finder.Item[]
  local items = {}

  for _, fff_item in ipairs(fff_result) do
    items[#items + 1] = {
      text = fff_item.name,
      -- fff items only carry `relative_path` (to fff's base_path); resolve it the way fff's UI does
      file = require("fff.utils").canonicalize_fff_path(fff_item.relative_path),
      status = git_porcelain[fff_item.git_status],
    }
  end

  return items
end

-- fff compares current_file against relative paths, so mirror picker_ui's get_current_file_cache
local function get_file_relpath(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" or vim.fn.filereadable(name) ~= 1 then
    return nil
  end

  local base = vim.fn.resolve(require("fff.conf").get().base_path)
  local rel = vim.fs.relpath(base, vim.fn.resolve(vim.fn.fnamemodify(name, ":p")))

  return rel ~= "." and rel or nil
end

---@class FFFSnacksConfig: snacks.picker.Config
---@field max_threads? number fff search threads (defaults to fff's config)

---@type FFFSnacksConfig
M.files = {
  title = "FFFiles",
  ---@param opts FFFSnacksConfig
  ---@param ctx snacks.picker.finder.ctx
  finder = function(opts, ctx)
    local picker_engine = init_fff(ctx)
    if not picker_engine then
      return {}
    end

    local fff_config = require("fff.conf").get()
    local query = ctx.filter.search
    local max_results = opts.limit or fff_config.max_results
    local max_threads = opts.max_threads or fff_config.max_threads
    local curr_buf_relpath = get_file_relpath(ctx.filter.current_buf)

    local result = picker_engine.search_files(query, curr_buf_relpath, max_results, max_threads)

    return to_snacks_items(result)
  end,

  format = function(item, picker)
    ---@type snacks.picker.Highlight[]
    local ret = {}

    if item.label then
      ret[#ret + 1] = { item.label, "SnacksPickerLabel" }
      ret[#ret + 1] = { " ", virtual = true }
    end

    if item.status then
      vim.list_extend(ret, format_git_status(item, picker))
    else
      -- keep filenames aligned with rows that have a git icon
      ret[#ret + 1] = { "  ", virtual = true }
    end

    vim.list_extend(ret, require("snacks").picker.format.filename(item, picker))

    if item.line then
      require("snacks").picker.highlight.format(item, item.line, ret)
      table.insert(ret, { " " })
    end

    return ret
  end,

  -- fff's default git.status_updates = "while_open" only tracks git status while a picker is open
  on_show = function()
    local ok, err = pcall(function()
      require("fff.file_picker").resume_git_status()
    end)

    if not ok then
      notify("Failed to resume fff git status: " .. tostring(err), vim.log.levels.WARN)
    end
  end,

  on_close = function()
    local ok, err = pcall(function()
      require("fff.file_picker").pause_git_status()
    end)

    if not ok then
      notify("Failed to pause fff git status: " .. tostring(err), vim.log.levels.WARN)
    end
  end,

  formatters = {
    file = {
      filename_first = true,
    },
  },
  live = true,
  show_empty = true,
}

-- fff live grep (in-memory index) as a snacks source
---@type snacks.picker.Config
M.grep = {
  live = true,
  format = "file",
  finder = function(opts, ctx)
    if ctx.filter.search == "" then
      return {}
    end

    if not init_fff(ctx) then
      return {}
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
M.sources = { files = M.files, grep = M.grep }

return M
