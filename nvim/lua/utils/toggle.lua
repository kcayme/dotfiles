local notify = require("utils.notification").notify
local M = {}

-- word -> its opposite, matched exactly. add your own pairs here (both directions)
---@type table<string, string>
M.opposites = {
  ["true"] = "false",
  ["false"] = "true",
  ["True"] = "False",
  ["False"] = "True",
  ["TRUE"] = "FALSE",
  ["FALSE"] = "TRUE",
}

-- treesitter node types that are boolean literals (grammars name them differently)
---@type table<string, boolean>
M.boolean_nodes = {
  ["true"] = true, -- lua, python, go, javascript, typescript, json, c
  ["false"] = true,
  boolean = true,
  boolean_literal = true,
  boolean_scalar = true, -- yaml
}

-- with a parser, only real boolean literals count (not strings, comments or identifiers).
-- without one there's nothing to check against, so any word in `M.opposites` flips
---@param row integer 0-based
---@param col integer 0-based byte offset
---@return boolean
local function is_boolean_node(row, col)
  if not vim.treesitter.get_parser(0) then
    return true
  end

  local node = vim.treesitter.get_node({ pos = { row, col } })

  return node ~= nil and M.boolean_nodes[node:type()] == true
end

-- operatorfunc, called by g@ so the flip can be repeated with `.`
function M._apply()
  local row, start_col, end_col = require("utils.case").word_range()

  if not row or not start_col or not end_col then
    return
  end

  local word = vim.api.nvim_buf_get_text(0, row, start_col, row, end_col, {})[1]
  local flipped = M.opposites[word]

  if not flipped or not is_boolean_node(row, start_col) then
    notify("Not a boolean: " .. word, vim.log.levels.WARN)
    return
  end

  vim.api.nvim_buf_set_text(0, row, start_col, row, end_col, { flipped })
end

-- flip the boolean under cursor, e.g. true <-> false, True <-> False
function M.flip()
  vim.o.operatorfunc = "v:lua.require'utils.toggle'._apply"
  -- dummy `l` motion, the range comes from word_range()
  vim.api.nvim_feedkeys("g@l", "nx", false)
end

return M
