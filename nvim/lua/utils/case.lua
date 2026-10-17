local notify = require("utils.notification").notify
local M = {}

---@alias CaseName "snake"|"screaming"|"kebab"|"camel"|"pascal"|string
---@alias CaseFormatter fun(parts: string[]): string

---@class CaseCycleOpts
---@field lsp? boolean rename all references via LSP instead of editing text

---@class CaseState
---@field order CaseName[] cases to cycle through, in order
---@field visual boolean true when started from charwise visual mode
---@field lsp? boolean rename all references via LSP

-- split "myHTTPServer" / "my-http_server" into { "my", "http", "server" }
---@param text string
---@return string[] parts lowercase words
local function split_words(text)
  text = text:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2"):gsub("[_%-]", " ")
  local parts = {}

  for part in text:gmatch("%S+") do
    parts[#parts + 1] = part:lower()
  end

  return parts
end

---@param word string
---@return string
local capitalize = function(word)
  return (word:gsub("^%l", string.upper))
end

-- available cases, each gets a list of lowercase words. add your own here
---@type table<CaseName, CaseFormatter>
M.formats = {
  snake = function(parts)
    return table.concat(parts, "_")
  end,
  screaming = function(parts)
    return table.concat(parts, "_"):upper()
  end,
  kebab = function(parts)
    return table.concat(parts, "-")
  end,
  camel = function(parts)
    return parts[1] .. table.concat(vim.tbl_map(capitalize, vim.list_slice(parts, 2)), "")
  end,
  pascal = function(parts)
    return table.concat(vim.tbl_map(capitalize, parts), "")
  end,
}

-- range of the word under cursor: treesitter leaf node, else a [%w_-]+ run
---@return integer? row 0-based
---@return integer? start_col 0-based byte offset
---@return integer? end_col 0-based byte offset, exclusive
local function word_range()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- cursor right after a word (e.g. on the "(" of a function name): use that word
  if col > 0 and not line:sub(col + 1, col + 1):match("[%w_%-]") then
    col = col - 1
  end

  local has_parser, node = pcall(vim.treesitter.get_node, { pos = { row - 1, col } })

  if has_parser and node and node:child_count() == 0 then
    local start_row, start_col, end_row, end_col = node:range()
    -- skip prose/comment leaves that contain more than one word
    if start_row == end_row and vim.treesitter.get_node_text(node, 0):match("^[%w_%-]+$") then
      return start_row, start_col, end_col
    end
  end

  local search_from = 1

  while true do
    -- 1-based, inclusive byte positions
    local match_start, match_end = line:find("[%w_%-]+", search_from)

    -- no more runs, or the next one starts past the cursor
    if not match_start or not match_end or match_start > col + 1 then
      return
    end

    if match_end > col then
      return row - 1, match_start - 1, match_end
    end

    search_from = match_end + 1
  end
end

-- range of the last g@ region (a charwise visual selection), nil if it spans multiple lines
---@return integer? row 0-based
---@return integer? start_col 0-based byte offset
---@return integer? end_col 0-based byte offset, exclusive
local function selection_range()
  local region = vim.fn.getregionpos(vim.fn.getpos("'["), vim.fn.getpos("']"), { type = "v" })

  if #region ~= 1 then
    return
  end

  -- each position is { bufnum, lnum, col, off }, 1-based
  local first_pos, last_pos = region[1][1], region[1][2]
  return first_pos[2] - 1, first_pos[3] - 1, last_pos[3]
end

-- next case in `order` that actually changes the word, wrapping back to the start
-- (a single word like "foo" is snake, kebab and camel at once)
---@param word string
---@param order CaseName[]
---@return string? converted nil when no case in `order` changes the word
local function next_case(word, order)
  local parts = split_words(word)
  local current_index = 0 -- not in any listed case: start from the first

  for index, name in ipairs(order) do
    if M.formats[name](parts) == word then
      current_index = index
      break
    end
  end

  for offset = 1, #order do
    local converted = M.formats[order[(current_index + offset - 1) % #order + 1]](parts)

    if converted ~= word then
      return converted
    end
  end
end

---@type CaseState
local state = { order = {}, visual = false }

-- operatorfunc, called by g@ so the conversion can be repeated with `.`
function M._apply()
  local row, start_col, end_col

  if state.visual then
    row, start_col, end_col = selection_range()
  else
    row, start_col, end_col = word_range()
  end

  if not row or not start_col or not end_col then
    return
  end

  local word = vim.api.nvim_buf_get_text(0, row, start_col, row, end_col, {})[1]
  local converted = next_case(word, state.order)

  if not converted then
    return
  end

  if state.lsp then
    if #vim.lsp.get_clients({ bufnr = 0, method = "textDocument/rename" }) > 0 then
      vim.api.nvim_win_set_cursor(0, { row + 1, start_col })
      vim.lsp.buf.rename(converted)
      return
    end

    notify("No LSP rename available", vim.log.levels.WARN)
  end

  vim.api.nvim_buf_set_text(0, row, start_col, row, end_col, { converted })
end

-- convert word under cursor (or charwise visual selection) to the next case
-- in `order`, e.g. { "snake", "camel" }. `opts.lsp` renames all references via LSP
---@param order CaseName[]
---@param opts? CaseCycleOpts
function M.cycle(order, opts)
  local visual = vim.fn.mode() == "v"

  for _, format in ipairs(order) do
    if not M.formats[format] then
      notify("Unsupported format: " .. format, vim.log.levels.WARN)
      return
    end
  end

  state = { order = order, visual = visual, lsp = opts and opts.lsp }
  vim.o.operatorfunc = "v:lua.require'utils.case'._apply"
  -- normal mode: dummy `l` motion, the range comes from word_range()
  vim.api.nvim_feedkeys(visual and "g@" or "g@l", "nx", false)
end

M.word_range = word_range

return M
