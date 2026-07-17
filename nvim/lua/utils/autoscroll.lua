local M = {}

local notify = require("utils.notification").notify
local uv = vim.uv or vim.loop

-- Dwell time per buffer scales with line count, clamped to [MIN, MAX]
local MIN_DWELL_MS = 60 * 1000
local MAX_DWELL_MS = 7 * 60 * 1000
local DWELL_MS_PER_LINE = 360 -- ~1000-line file reaches the max
local MIN_TICK_MS = 800
local MAX_TICK_MS = 4000
local MAX_LISTED_BUFFERS = 30
-- Require this many cursor movements in a buffer (on top of the dwell time) before switching
local MIN_MOVES = 3
local MAX_MOVES = 10

local state = {
  running = false,
  timer = nil,
  bufnr = nil,
  dwell_ms = 0,
  elapsed_ms = 0,
  moves = 0,
  moves_needed = 0,
  opened = {}, -- bufnrs this module opened itself, for cleanup on stop
  files = nil, -- cached project file list
}

local function project_files()
  if state.files then
    return state.files
  end

  local files = vim.fn.systemlist("git ls-files")
  if vim.v.shell_error ~= 0 then
    files = vim.fn.glob("**/*", false, true)
  end

  state.files = vim.tbl_filter(function(path)
    return vim.fn.filereadable(path) == 1
  end, files)

  return state.files
end

local function listed_buffers()
  return vim.tbl_filter(function(bufnr)
    return vim.bo[bufnr].buflisted and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == ""
  end, vim.api.nvim_list_bufs())
end

local function feed(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

local function random_line()
  local count = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_win_set_cursor(0, { math.random(count), 0 })
  feed("zz")
end

local actions = {
  { weight = 5, act = function() feed(math.random(2, 6) .. "<C-e>") end },
  { weight = 2, act = function() feed(math.random(2, 6) .. "<C-y>") end },
  { weight = 2, act = function() feed("<C-d>") end },
  { weight = 1, act = function() feed("<C-u>") end },
  { weight = 2, act = random_line },
  { weight = 1, act = function() feed(math.random(2) == 1 and "gg" or "G") end },
  { weight = 4, act = function() feed(math.random(7, 15) .. "w") end },
  { weight = 2, act = function() feed(math.random(7, 15) .. "b") end },
  { weight = 1, act = function() feed("e") end },
  { weight = 4, act = function() feed(math.random(5, 10) .. "j") end },
  { weight = 3, act = function() feed(math.random(5, 10) .. "k") end },
  { weight = 2, act = function() feed(math.random(5, 10) .. "l") end },
  { weight = 2, act = function() feed(math.random(5, 10) .. "h") end },
}

local total_weight = 0
for _, action in ipairs(actions) do
  total_weight = total_weight + action.weight
end

local function random_action()
  -- Wrap to top once we've scrolled down to the end of the file
  if vim.fn.line("w0") > 1 and vim.fn.line("w$") >= vim.api.nvim_buf_line_count(0) then
    feed("gg")
    return
  end

  local roll = math.random(total_weight)
  for _, action in ipairs(actions) do
    roll = roll - action.weight
    if roll <= 0 then
      action.act()
      return
    end
  end
end

local function switch_buffer()
  local open = vim.tbl_filter(function(bufnr)
    return bufnr ~= state.bufnr
  end, listed_buffers())

  local candidates = vim.deepcopy(open)
  if #listed_buffers() < MAX_LISTED_BUFFERS then
    for _, path in ipairs(project_files()) do
      table.insert(candidates, path)
    end
  end

  if #candidates == 0 then
    return
  end

  local pick = candidates[math.random(#candidates)]
  if type(pick) == "string" then
    local existed = vim.fn.bufexists(pick) == 1
    vim.cmd.edit(vim.fn.fnameescape(pick))
    if not existed then
      table.insert(state.opened, vim.api.nvim_get_current_buf())
    end
  else
    vim.api.nvim_set_current_buf(pick)
  end

  state.bufnr = vim.api.nvim_get_current_buf()
  state.elapsed_ms = 0
  state.moves = 0
  state.moves_needed = math.random(MIN_MOVES, MAX_MOVES)
  local lines = vim.api.nvim_buf_line_count(state.bufnr)
  state.dwell_ms = math.min(math.max(MIN_DWELL_MS, lines * DWELL_MS_PER_LINE), MAX_DWELL_MS)
end

local function safe_to_act()
  return vim.api.nvim_get_current_buf() == state.bufnr
    and vim.fn.mode() == "n"
    and vim.fn.getcmdtype() == ""
end

local function tick()
  if not state.running then
    return
  end

  local delay = math.random(MIN_TICK_MS, MAX_TICK_MS)
  state.elapsed_ms = state.elapsed_ms + delay

  if safe_to_act() then
    if state.elapsed_ms >= state.dwell_ms and state.moves >= state.moves_needed then
      switch_buffer()
    else
      random_action()
      state.moves = state.moves + 1
    end
  end

  state.timer:start(delay, 0, vim.schedule_wrap(tick))
end

local function start()
  math.randomseed(uv.hrtime())
  state.running = true
  state.timer = uv.new_timer()
  state.opened = {}
  state.files = nil
  state.bufnr = nil
  state.dwell_ms = 0
  state.elapsed_ms = 0

  switch_buffer()
  state.timer:start(math.random(MIN_TICK_MS, MAX_TICK_MS), 0, vim.schedule_wrap(tick))

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("AutoScroll", { clear = true }),
    callback = M.stop,
  })

  notify("auto-scroll: started", "info")
end

function M.stop()
  if not state.running then
    return
  end

  state.running = false
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end
  vim.api.nvim_del_augroup_by_name("AutoScroll")

  for _, bufnr in ipairs(state.opened) do
    if vim.api.nvim_buf_is_valid(bufnr) and not vim.bo[bufnr].modified and bufnr ~= vim.api.nvim_get_current_buf() then
      vim.cmd.bdelete(bufnr)
    end
  end
  state.opened = {}

  notify("auto-scroll: stopped", "info")
end

function M.toggle()
  if state.running then
    M.stop()
  else
    start()
  end
end

return M
