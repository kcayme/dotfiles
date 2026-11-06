local notify = require("utils.notification").notify

vim.api.nvim_create_user_command("FormatToggle", function(args)
  local opts = { title = "conform.nvim" }
  local is_global = not args.bang

  if is_global then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    if vim.g.disable_autoformat then
      notify("Autoformat-on-save disabled globally", "info", opts)
    else
      notify("Autoformat-on-save enabled globally", "info", opts)
    end
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    if vim.b.disable_autoformat then
      notify("Autoformat-on-save disabled for this buffer", "info", opts)
    else
      notify("Autoformat-on-save enabled for this buffer", "info", opts)
    end
  end
end, {
  desc = "Toggle autoformat-on-save",
  bang = true,
})

-- Toggle an LSP display feature globally, or for the current buffer with !
local function lsp_feature_toggle(name, label, feature, method)
  vim.api.nvim_create_user_command(name, function(args)
    local supported = #vim.lsp.get_clients({ bufnr = 0, method = method }) > 0
    if args.bang and not supported then
      notify(label .. " not available: no attached LSP supports it in this buffer", vim.log.levels.WARN)
      return
    end

    local filter = args.bang and { bufnr = 0 } or nil
    local enable = not feature.is_enabled(filter)
    feature.enable(enable, filter)

    local scope = args.bang and "for this buffer" or "globally"
    notify(label .. " " .. (enable and "enabled " or "disabled ") .. scope, "info")
    if not supported then
      notify(label .. " not available in this buffer: no attached LSP supports it", vim.log.levels.WARN)
    end
  end, {
    desc = "Toggle LSP " .. label:lower() .. " (! for current buffer only)",
    bang = true,
  })
end

lsp_feature_toggle("InlayHintToggle", "Inlay hints", vim.lsp.inlay_hint, "textDocument/inlayHint")
lsp_feature_toggle("CodeLensToggle", "Code lens", vim.lsp.codelens, "textDocument/codeLens")

-- Show linters for the current buffer's file type
vim.api.nvim_create_user_command("LintInfo", function()
  local filetype = vim.bo.filetype
  local linters = require("lint").linters_by_ft[filetype]

  if linters then
    print("Linters for " .. filetype .. ": " .. table.concat(linters, ", "))
  else
    print("No linters configured for filetype: " .. filetype)
  end
end, {})

vim.api.nvim_create_user_command("LspInfo", function()
  if vim.fn.has("nvim-0.12") == 1 then
    vim.cmd("checkhealth vim.lsp")
  end
end, { desc = "LSP info" })

vim.api.nvim_create_user_command("LspRestart", function(args)
  vim.cmd("lsp restart " .. args.args)
end, { desc = "Restart LSP client(s)", nargs = "*" })

vim.api.nvim_create_user_command("WrapToggle", function(args)
  vim.o.wrap = not vim.o.wrap

  notify("line wrap: " .. tostring(vim.o.wrap), "info")
end, { desc = "Toggle line wrap" })

vim.api.nvim_create_user_command("AutoScrollToggle", function()
  require("utils.autoscroll").toggle()
end, { desc = "Toggle random buffer auto-scrolling" })

vim.api.nvim_create_user_command("RandUUID", function()
  local b = { vim.uv.random(16):byte(1, 16) }
  b[7] = bit.bor(bit.band(b[7], 0x0f), 0x40) -- version 4
  b[9] = bit.bor(bit.band(b[9], 0x3f), 0x80) -- RFC 4122 variant
  local uuid = string.format("%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x", unpack(b))
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local in_string = false
  local parser = vim.treesitter.get_parser(0, nil, { error = false })
  if parser then
    parser:parse({ row - 1, row })
    local node = vim.treesitter.get_node()
    while node and not node:type():find("string") do
      -- `${...}` / f"{...}" hold code, not string content
      if node:type():find("substitution") or node:type():find("interpolation") then
        node = nil
      else
        node = node:parent()
      end
    end
    if node then
      local _, _, end_row, end_col = node:range()
      -- on the closing quote the UUID would land after the string
      in_string = not (end_row == row - 1 and end_col == col + 1)
    end
  else
    -- no parser: the UUID lands between the char under the cursor and the next one
    in_string = vim.api.nvim_get_current_line():sub(col + 1, col + 2):find("[\"'`]") ~= nil
  end
  if not in_string then
    uuid = '"' .. uuid .. '"'
  end
  vim.api.nvim_put({ uuid }, "c", true, true)
end, { desc = "Insert a random v4 UUID after the cursor, quoted unless inside a string" })

vim.api.nvim_create_user_command("PickGitWorktree", function()
  local items = {}
  for _, line in ipairs(vim.fn.systemlist({ "git", "worktree", "list", "--porcelain" })) do
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
        ("Switched to %s (%s)\nReopened %d buffer(s), closed %d"):format(
          item.branch,
          vim.fn.fnamemodify(item.path, ":~"),
          reopened,
          #moves - reopened
        ),
        "info",
        { title = "Git Worktree" }
      )
      if cur_moved and not cur_target then
        require("core.config.pickers").files({ backend = "snacks" })
      end
    end,
  })
end, { desc = "Pick a git worktree, cd into it, and move open buffers over" })
