vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  desc = "Change the cursor in the tree for the current focused buffer",
  group = vim.api.nvim_create_augroup("nvim-tree-cursor-focus", { clear = true }),
  callback = function()
    local api = require("nvim-tree.api")
    api.tree.find_file({ open = false, focus = false })
  end,
})

--  This function gets run when an LSP attaches to a particular buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local picker = require("snacks").picker
    -- Jump to the implementation of the word under your cursor.
    --  Useful when your language has ways of declaring types without an actual implementation.
    map("<leader>gi", picker.lsp_implementations, "[G]oto [I]mplementation")

    -- Jump to the type of the word under your cursor.
    --  Useful when you're not sure what type a variable is and you want to see
    --  the definition of its *type*, not where it was *defined*.
    map("<leader>gt", picker.lsp_type_definitions, "[G]o [T]ype Definition")

    -- Fuzzy find all the symbols in your current document.
    --  Symbols are things like variables, functions, types, etc.
    map("<leader>@", function()
      picker.lsp_symbols({
        layout = {
          preset = "vscode",
        },
      })
    end, "[D]ocument [S]ymbols")

    -- Fuzzy find all the symbols in your current workspace
    --  Similar to document symbols, except searches over your whole project.
    map("<leader>gs", picker.lsp_workspace_symbols, "[W]orkspace [S]ymbols")

    -- Rename the variable under your cursor
    -- map("<F2>", vim.lsp.buf.rename, "[F2] Rename")
    map("<F2>", function()
      -- if client and client.server_capabilities.renameProvider then
      -- wrap rename input to have on_confirm callback
      local curr_name = vim.fn.expand("<cword>")
      vim.ui.input({ prompt = "Rename to: ", default = curr_name }, function(input)
        vim.lsp.buf.rename(input)
        vim.defer_fn(function()
          vim.cmd("wa")
        end, 1000)
      end)
    end, "[F2] Rename")

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.

    map("<leader>ca", function()
      require("tiny-code-action").code_action()
    end, "[C]ode [A]ction")
    -- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap
    map(",", vim.lsp.buf.hover, "Hover Documentation")

    -- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("gD", picker.lsp_declarations, "[G]oto [D]eclaration")

    -- map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("gd", picker.lsp_definitions, "[G]oto [D]efinition")

    map("<leader>gd", function()
      vim.cmd("vsplit")
      picker.lsp_definitions()
    end, "[G]oto [D]efinition in new vsplit")

    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, { desc = "Signature Help" })

    map("gr", picker.lsp_references, "[G]oto [R]eferences")

    map("<leader>gr", function()
      picker.lsp_references({ filter = { buf = true } })
    end, "[G]oto [R]eferences in current buffer")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- Prefer LSP folding if client supports it
    if client and client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})

vim.api.nvim_create_user_command("FormatToggle", function(args)
  local notify = require("notify")
  local function show_notification(message, level)
    notify(message, level, { title = "conform.nvim" })
  end
  local is_global = not args.bang
  if is_global then
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    if vim.g.disable_autoformat then
      show_notification("Autoformat-on-save disabled globally", "info")
    else
      show_notification("Autoformat-on-save enabled globally", "info")
    end
  else
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    if vim.b.disable_autoformat then
      show_notification("Autoformat-on-save disabled for this buffer", "info")
    else
      show_notification("Autoformat-on-save enabled for this buffer", "info")
    end
  end
end, {
  desc = "Toggle autoformat-on-save",
  bang = true,
})

-- Make :bd and :q behave as usual when tree is visible
vim.api.nvim_create_autocmd({ "BufEnter", "QuitPre" }, {
  nested = false,
  callback = function(e)
    local tree = require("nvim-tree.api").tree

    -- Nothing to do if tree is not opened
    if not tree.is_visible() then
      return
    end

    -- How many focusable windows do we have? (excluding e.g. incline status window)
    local winCount = 0
    for _, winId in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winId).focusable then
        winCount = winCount + 1
      end
    end

    -- We want to quit and only one window besides tree is left
    if e.event == "QuitPre" and winCount == 2 then
      vim.api.nvim_cmd({ cmd = "qall" }, {})
    end

    -- :bd was probably issued an only tree window is left
    -- Behave as if tree was closed (see `:h :bd`)
    if e.event == "BufEnter" and winCount == 1 then
      -- Required to avoid "Vim:E444: Cannot close last window"
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last buffer used before closing
        tree.toggle({ find_file = true, focus = true })
        -- re-open nivm-tree
        tree.toggle({ find_file = true, focus = false })
      end, 10)
    end
  end,
})

-- related to lualine macro recording component
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    require("lualine").refresh({ place = { "statusline" } })
  end,
})

-- The register does not clean up immediately after
-- recording stops, so we wait a bit (50ms) before refreshing.
vim.api.nvim_create_autocmd("RecordingLeave", {
  callback = function()
    local timer = vim.loop.new_timer()
    timer:start(
      50,
      0,
      vim.schedule_wrap(function()
        require("lualine").refresh({ place = { "statusline" } })
      end)
    )
  end,
})

vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWritePost",
  "InsertLeave",
}, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function()
    local lint = require("lint")
    lint.try_lint()
    vim.diagnostic.config({ virtual_text = false })
  end,
})

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

-- https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
  pattern = "NvimTreeSetup",
  callback = function()
    local events = require("nvim-tree.api").events
    events.subscribe(events.Event.NodeRenamed, function(data)
      if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
        data = data
        Snacks.rename.on_rename_file(data.old_name, data.new_name)
      end
    end)
  end,
})
