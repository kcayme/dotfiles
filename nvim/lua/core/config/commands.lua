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
