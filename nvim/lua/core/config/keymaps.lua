local map = vim.keymap.set

map("n", "<Esc>", function()
  -- clear highlights
  vim.cmd("nohlsearch")
  -- clear notifications
  require("notify").dismiss()
end, { desc = "Clear notifs and highlights" })

-- INFO: DIAGNOSTICS =====================================================================
---@param jumpCount number
local function jumpWithVirtLineDiags(jumpCount)
  pcall(vim.api.nvim_del_augroup_by_name, "jumpWithVirtLineDiags") -- prevent autocmd for repeated jumps

  vim.diagnostic.jump({ count = jumpCount })

  local initialVirtTextConf = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = { current_line = true },
  })

  vim.defer_fn(function() -- deferred to not trigger by jump itself
    vim.api.nvim_create_autocmd("CursorMoved", {
      desc = "User(once): Reset diagnostics virtual lines",
      once = true,
      group = vim.api.nvim_create_augroup("jumpWithVirtLineDiags", {}),
      callback = function()
        vim.diagnostic.config({ virtual_lines = false, virtual_text = initialVirtTextConf })
      end,
    })
  end, 1)
end

map("n", "<leader>]", function()
  jumpWithVirtLineDiags(1)
end, { desc = "󰒕 Next diagnostic" })
map("n", "<leader>[", function()
  jumpWithVirtLineDiags(-1)
end, { desc = "󰒕 Prev diagnostic" })

-- INFO: NAVIGATIONS ====================================================================
map({ "n", "v" }, "gh", "^", { desc = "Go to start of line" })
map({ "n", "v" }, "gl", "$", { desc = "Go to end of line" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up with scrolloff" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with scrolloff" })
map("n", "N", "Nzzzv", { desc = "Go to Previous search result", noremap = true, silent = true })
map("n", "n", "nzzzv", { desc = "Go to Next search result", noremap = true, silent = true })
map("n", "j", function()
  local api = require("nvim-tree.api")
  if api.tree.is_tree_buf() then
    return "j"
  end
  return "jzz"
end, { silent = true, expr = true, noremap = true })

map("n", "k", function()
  local api = require("nvim-tree.api")
  if api.tree.is_tree_buf() then
    return "k"
  end
  return "kzz"
end, { silent = true, expr = true, noremap = true })
map("n", ")", "<C-i>zz", { noremap = true, silent = true, desc = "Jump to Next Position" })
map("n", "(", "<C-o>zz", { noremap = true, silent = true, desc = "Jump to Previous Position" })

-- INFO: BUFFERS AND WINDOWS =============================================================
map("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Go to Previous Buffer" })
map({ "n" }, "<Leader>X", "<cmd>close<cr>", { desc = "Close window" })
map({ "n" }, "<Leader>|", "<cmd>vsplit<cr>", { desc = "Vertical window split" })
-- map({ "n" }, "<Leader><S-l>", "<C-W>L", { desc = "Move current buffer to right" })
-- map({ "n" }, "<Leader><S-h>", "<C-W>H", { desc = "Move current buffer to left" })
map({ "n" }, "<Leader><tab>", "<cmd>tabnext<cr>", { desc = "Go to next tab" })
map({ "n" }, "<Leader>tc", "<cmd>tabclose<cr>", { desc = "[T]ab [C]lose" })
map({ "n" }, "-", "15<C-W><", { desc = "Decrease buffer width" })
map({ "n" }, "=", "15<C-W>>", { desc = "Increase buffer width" })
map({ "n" }, "+", "5<C-W>+", { desc = "Increase buffer height" })
map({ "n" }, "_", "5<C-W>-", { desc = "Decrease buffer height" })
-- close buffer if it is in bufferline; else, close window
map({ "n" }, "<Leader>x", function()
  local noice = require("noice")
  -- local buffers = require("bufferline").get_elements().elements
  -- local currentBufferId = vim.api.nvim_get_current_buf()
  -- FIXME:
  -- for _, buf in ipairs(buffers) do
  --   if buf.id == currentBufferId then
  Snacks.bufdelete()
  noice.notify("Buffer closed")

  --     return
  --   end
  -- end

  -- noice.notify("Window closed")
  -- vim.cmd("close")
end, { desc = "Close vertical window split" })

-- INFO: MOTIONS AND EDITING ============
-- save file
map({ "n", "v" }, "<C-s>", "<cmd>w<cr>", {})

-- keep previously yanked word
map({ "v" }, "p", '"_dP', { noremap = false })

-- indent on visual and normal mode
map({ "n" }, "<tab>", ">>")
map({ "n" }, "<s-tab>", "<<")
map({ "v", "x" }, "<tab>", ">gv", { noremap = true })
map({ "v", "x" }, "<s-tab>", "<gv", { noremap = true })

-- fold
map({ "n" }, "zx", "za", { desc = "Toggle fold under cursor" })
map({ "n" }, "zcf", "zC", { desc = "Recursive fold under cursor" })
map({ "n" }, "zcu", "zo", { desc = "Recursive unfold under cursor" })
map({ "n" }, "zf", "zM", { desc = "Fold all" })
map({ "n" }, "zu", "zR", { desc = "Unfold all" })

map("i", "jj", "<Esc>", { silent = true, noremap = false })
map("n", "<C-s>", "<cmd>w<cr>", { silent = false, desc = "Save File" })

-- nvim-surround
vim.api.nvim_set_keymap("n", "<Leader>lw", "ysiw", { noremap = false, desc = "Surround [w]ord" })
vim.api.nvim_set_keymap("n", "<Leader>lW", "ysiW", { noremap = false, desc = "Surround [W]ord" })
vim.api.nvim_set_keymap("n", "<Leader>la", "ysa", { noremap = false, desc = "Surround delimited" })
vim.api.nvim_set_keymap("n", "<Leader>ll", "yss", { noremap = false, desc = "Surround line" })

-- git diff
map("n", "<leader>gc", "<cmd>DiffviewOpen<cr>", { desc = "Git Diff View" })

-- search and show results in loclist
map("n", "<leader>/", function()
  Snacks.input.input({
    prompt = "Search",
    default = "",
    icon = "",
  }, function(input)
    if not input or input == "" then
      print("Search aborted")
      return
    end

    -- Set the search register so highlights and "n/N" work
    vim.fn.setreg("/", input)

    -- Run lvimgrep on the current buffer (%)
    vim.cmd("lvimgrep /" .. vim.fn.escape(input, "/") .. "/ %")

    require("trouble").toggle({ mode = "loclist", focus = true })

    vim.cmd("normal! n")
  end)
end)

-- INFO: PICKERS =======================================
local Picker = require("core.config.interfaces")

map("n", "<leader>ff", function()
  Picker.files({ backend = "snacks" })
end, { desc = "Find Files" })

map("n", "<leader>fg", function()
  Picker.grep({ backend = "snacks", hidden = true })
end, { desc = "Live Grep" })

map("n", "<leader>frg", function()
  Picker.resume({ backend = "snacks" })
end, { desc = "Resume" })

map("n", "<leader>fo", function()
  Picker.buffers({ backend = "snacks" })
end, { desc = "Find Open Buffers" })

map("n", "<leader>fj", function()
  Picker.jumps({ backend = "snacks" })
end, { desc = "Find Jumplist" })

map("n", "<leader>ft", function()
  Picker.todo_comments({ backend = "snacks" })
end, { desc = "Find Todo List" })

map({ "n", "x" }, "<leader>fw", function()
  Picker.grep_word({ backend = "snacks" })
end, { desc = "Grep Word" })

map("n", "<leader>fd", function()
  Picker.diagnostics({ backend = "snacks" })
end, { desc = "Find Diagnostics" })

map("n", "<leader>fh", function()
  Picker.help({ backend = "snacks" })
end, { desc = "Find Help Pages" })

map("n", "<leader>fk", function()
  Picker.keymaps({ backend = "snacks" })
end, { desc = "Find Keymaps" })

-- map("n", "<leader>fc", function()
--   Picker.smart({ backend = "fzf", cwd_only = true })
-- end, { desc = "Find Smart" })

map("n", "<leader><leader>", function()
  Picker.smart({ backend = "fff" })
end, { desc = "Global Find" })

map("n", "<leader>fr", function()
  Picker.registers({ backend = "snacks" })
end, { desc = "Find Registers" })
