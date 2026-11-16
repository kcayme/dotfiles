local picker = require("snacks").picker
local notify = require("utils.notification").notify

local M = {}

M.files = picker.files
M.grep = picker.grep
M.grep_word = picker.grep_word
M.buffers = picker.buffers
M.keymaps = picker.keymaps
M.diagnostics = picker.diagnostics
M.help = picker.help
M.jumps = picker.jumps
M.lsp_implementations = picker.lsp_implementations
M.lsp_type_definitions = picker.lsp_type_definitions
M.lsp_symbols = picker.lsp_symbols
M.lsp_workspace_symbols = picker.lsp_workspace_symbols
M.lsp_declarations = picker.lsp_declarations
M.lsp_definitions = picker.lsp_definitions
M.lsp_references = picker.lsp_references
M.todo_comments = picker.todo_comments
M.registers = picker.registers
M.resume = picker.resume
M.undo = picker.undo
M.commands = picker.commands

function M.tabs(opts)
  local items = vim.tbl_map(function(tab)
    local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tab)))
    local nr = vim.api.nvim_tabpage_get_number(tab)
    return { text = nr .. " " .. (name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")), tab = tab, file = name }
  end, vim.api.nvim_list_tabpages())
  picker.pick(vim.tbl_extend("force", {
    title = "Tabs",
    items = items,
    format = "text",
    confirm = function(p, item)
      p:close()
      vim.api.nvim_set_current_tabpage(item.tab)
    end,
  }, opts or {}))
end

-- pick a git worktree, cd into it, and move open buffers over
function M.git_worktrees()
  local items = {}
  local dirs = vim.fn.systemlist({ "git", "worktree", "list", "--porcelain" })

  for _, line in ipairs(dirs) do
    local path = line:match("^worktree (.+)")
    if path then
      items[#items + 1] = { path = vim.uv.fs_realpath(path) or path, branch = "(detached)" }
    elseif line:match("^HEAD ") then
      items[#items].commit = line:match("^HEAD (%x+)")
    elseif line:match("^branch ") then
      items[#items].branch = line:match("^branch refs/heads/(.+)")
    end
  end

  local current = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })[1]
  for _, item in ipairs(items) do
    item.text = item.branch .. " " .. item.path
    item.current = item.path == current
  end
  if items[1] then
    items[1].main = true -- git always lists the main worktree first
  end

  Snacks.picker({
    title = "Git Worktrees",
    items = items,
    format = function(item)
      return {
        { item.current and "* " or "  ", "SnacksPickerGitBranchCurrent" },
        { item.main and "\u{f015} " or "  ", "Special" },
        { item.branch, "SnacksPickerGitBranch" },
        { "  " },
        { vim.fn.fnamemodify(item.path, ":~"), "SnacksPickerDir" },
      }
    end,
    preview = function(ctx)
      Snacks.picker.preview.cmd({
        "git",
        "--no-pager",
        "diff",
        "--color=always",
        "--stat=" .. vim.api.nvim_win_get_width(ctx.win),
        ctx.item.commit,
      }, ctx)
    end,
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      -- buffers from other worktrees of this repo; longest root wins so nested worktrees resolve correctly
      local moves = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local file = vim.bo[buf].buflisted and vim.uv.fs_realpath(vim.api.nvim_buf_get_name(buf))
        local owner
        for _, wt in ipairs(items) do
          if file and vim.startswith(file, wt.path .. "/") and (not owner or #wt.path > #owner.path) then
            owner = wt
          end
        end
        if owner and owner ~= item then
          local target = item.path .. file:sub(#owner.path + 1)
          moves[#moves + 1] = { buf = buf, target = vim.uv.fs_stat(target) and target or nil }
        end
      end

      for _, m in ipairs(moves) do
        if vim.bo[m.buf].modified then
          local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(m.buf), ":~:.")
          local choice = vim.fn.confirm("Unsaved changes in " .. name, "&Save\n&Discard")
          if choice == 1 then
            vim.api.nvim_buf_call(m.buf, function()
              vim.cmd.write()
            end)
          elseif choice ~= 2 then
            notify("Worktree switch cancelled", "warn", { title = "Git Worktree" })
            return
          end
        end
      end

      local cur = vim.api.nvim_get_current_buf()
      local cur_moved, cur_target, reopened = false, nil, 0
      vim.cmd.cd(item.path)
      for _, m in ipairs(moves) do
        if m.target then
          reopened = reopened + 1
          local new = vim.fn.bufadd(m.target)
          vim.bo[new].buflisted = true -- left unloaded; it loads when shown in a window
          for _, win in ipairs(vim.fn.win_findbuf(m.buf)) do
            vim.api.nvim_win_set_buf(win, new)
          end
        end
        if m.buf == cur then
          cur_moved, cur_target = true, m.target
        end
        -- Snacks.bufdelete only needed to keep windows open; hidden buffers can go directly
        if #vim.fn.win_findbuf(m.buf) > 0 then
          Snacks.bufdelete({ buf = m.buf, force = true })
        else
          vim.api.nvim_buf_delete(m.buf, { force = true })
        end
      end

      notify(
        ("Switched to %s (%s)\n"):format(item.branch, vim.fn.fnamemodify(item.path, ":~")),
        "info",
        { title = "Git Worktree" }
      )
      if cur_moved and not cur_target then
        require("core.config.pickers").files({ backend = "snacks" })
      end
    end,
  })
end

---@type snacks.picker.Config
M.line_source = {
  live = true,
  format = "file",
  finder = function(_, ctx)
    local buf = ctx.filter.current_buf
    local count = vim.api.nvim_buf_line_count(buf)
    local line, col = ctx.filter.search:match("^(%d+):?(%d*)$")
    line = math.min(tonumber(line) or vim.api.nvim_win_get_cursor(ctx.filter.current_win)[1], count)
    col = math.max((tonumber(col) or 1) - 1, 0)
    return {
      {
        text = line .. ":" .. col,
        buf = buf,
        file = vim.api.nvim_buf_get_name(buf),
        pos = { line, col },
        line = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1],
      },
    }
  end,
}

-- only gitignored files (fff's index never includes them)
---@type snacks.picker.Config
M.gitignored = {
  format = "file",
  finder = function(opts, ctx)
    local cwd = ctx:git_root()
    return require("snacks.picker.source.proc").proc(
      ctx:opts({
        cmd = "git",
        args = { "ls-files", "--others", "--ignored", "--exclude-standard" },
        cwd = cwd,
        ---@param item snacks.picker.finder.Item
        transform = function(item)
          item.cwd = cwd
          item.file = item.text
          item.status = "!!"
        end,
      }),
      ctx
    )
  end,
}

-- custom sources the unified picker can name with `backend = "snacks"` (other names fall through to snacks' own)
M.sources = { line = M.line_source, gitignored = M.gitignored }

return M
