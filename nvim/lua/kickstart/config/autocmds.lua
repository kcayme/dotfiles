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
    -- Prefer LSP folding if client supports it
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end

    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

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
    map("<leader>@", picker.lsp_symbols, "[D]ocument [S]ymbols")

    -- Fuzzy find all the symbols in your current workspace
    --  Similar to document symbols, except searches over your whole project.
    map("<leader>gs", picker.lsp_workspace_symbols, "[W]orkspace [S]ymbols")

    -- Rename the variable under your cursor
    --  Most Language Servers support renaming across files, etc.
    map("<F2>", vim.lsp.buf.rename, "[F2] Rename")

    -- Execute a code action, usually your cursor needs to be on top of an error
    -- or a suggestion from your LSP for this to activate.
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    -- Opens a popup that displays documentation about the word under your cursor
    --  See `:help K` for why this keymap
    map(",", vim.lsp.buf.hover, "Hover Documentation")

    -- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("gD", picker.lsp_definitions, "[G]oto [D]eclaration")

    -- map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("gd", picker.lsp_definitions, "[G]oto [D]efinition")

    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, { desc = "Signature Help" })

    map("gr", picker.lsp_references, "[G]oto [R]eferences")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
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
  end,
})
