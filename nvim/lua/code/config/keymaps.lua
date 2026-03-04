-- [[ Basic Keymaps ]]
-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.api.nvim_set_keymap("n", "j", "gj", { silent = true, noremap = false })
vim.api.nvim_set_keymap("n", "k", "gk", { silent = true, noremap = false })
vim.api.nvim_set_keymap("i", "jj", "<Esc>", { silent = true, noremap = false })

-- helper function
local function notify(cmd)
  -- return string.format("<cmd>call VSCodeNotify('%s')<CR>", cmd)
  return string.format("<cmd>lua require('vscode').call('%s')<CR>", cmd)
end

-- VSCode bindings:
-- Sync undo and redo
vim.keymap.set("n", "u", notify("undo"))
vim.keymap.set("n", "<C-r>", notify("redo"))
vim.keymap.set("n", "<C-s>", notify("workbench.action.files.save"))
vim.keymap.set("n", "<Leader><Leader>", notify("workbench.action.quickOpenPreviousEditor"), { silent = false })
vim.keymap.set("n", "<Leader>gg", notify("git-graph.view"), { silent = false, desc = "Git graph open" })
vim.keymap.set("n", "<Leader>ff", notify("periscope.search"), { silent = false, desc = "Find Files" })
vim.keymap.set("n", "<Leader>fg", notify("periscope.searchFiles"), { silent = false, desc = "Find Within Files" })
vim.keymap.set(
  "n",
  "<Leader>fw",
  notify("find-it-faster.findWithinFiles"),
  { silent = false, desc = "find-it-faster-within-files" }
)
--vim.keymap.set("n", "<Leader>f", notify("workbench.action.findInFiles"), { silent = false })
vim.keymap.set("n", "<Leader>m", notify("workbench.action.toggleMultiCursorModifier"), {})
--find-it-faster.findFiles
--vim.keymap.set({'n','v' }, '<S-k>', "<cmd>call VSCodeCall('editor.action.moveLinesUpAction')<CR>", { silent = true, noremap = false })
--vim.keymap.set({'n','v' }, '<S-j>', "<cmd>call VSCodeCall('editor.action.moveLinesDownAction')<CR>", { silent = true, noremap = false })
--vim.keymap.set({'n','v' }, '<S-k>', "<cmd>call VSCodeCall('editor.action.moveLinesUpAction')<CR>", { silent = true, noremap = false })
--vim.keymap.set('n', '<C-u>', "40kzz", { silent = false,noremap = true })

--jump to next problem
vim.keymap.set("n", "<Leader>]", notify("go-to-next-error.next.warning"), {})
vim.keymap.set("n", "<Leader>[", notify("go-to-next-error.prev.warning"), {})

-- run test on cursor
vim.keymap.set("n", "<Leader>gt", notify("go.test.cursor"), { silent = false, desc = "Git graph open" })

-- Folding keympas
vim.keymap.set("n", "zx", notify("editor.toggleFold"), { silent = false })
vim.keymap.set("n", "zcx", notify("editor.toggleFoldRecursively"), { silent = false })
vim.keymap.set("n", "zaf", notify("editor.foldAll"), { silent = true })
vim.keymap.set("n", "zau", notify("editor.unfoldAll"), { silent = true })
vim.keymap.set("n", "zcu", notify("editor.unfoldRecursively"), { silent = true })
vim.keymap.set("n", "zcf", notify("editor.foldRecursively"), { silent = true })
-- vim.keymap.set("n", "zf", notify("editor.fold"), { silent = true })
-- vim.keymap.set("n", "zo", notify("editor.unfold"), { silent = true })
-- Hop.vim bindings
local hop = require("hop")
local hop_position = require("hop.hint").HintPosition
-- normal mode (easymotion-like)
vim.api.nvim_set_keymap("n", "<Leader>b", "<cmd>HopWordBC<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>w", "<cmd>HopWordAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>j", "<cmd>HopLineStart<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<Leader>k", "<cmd>HopLineStartBC<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<Leader>f", "<cmd>HopPattern<CR>", { noremap = true })
vim.keymap.set({ "n", "v" }, "<Leader>e", function()
  hop.hint_words({ hint_position = hop_position.END })
end, { noremap = true })
-- visual mode (easymotion-like)
vim.api.nvim_set_keymap("v", "<Leader>w", "<cmd>HopWordAC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>b", "<cmd>HopWordBC<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", "<Leader>j", "<cmd>HopLineStart<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("v", "<Leader>f", "<cmd>HopPattern<CR>", { noremap = true })

-- normal mode (sneak-like)
vim.api.nvim_set_keymap("n", "<Leader>h", "<cmd>HopChar2AC<CR>", { noremap = false })
vim.api.nvim_set_keymap("n", "<Leader>H", "<cmd>HopChar2BC<CR>", { noremap = false })

---- visual mode (sneak-like)
vim.api.nvim_set_keymap("v", "<Leader>h", "<cmd>HopChar2AC<CR>", { noremap = false })
vim.api.nvim_set_keymap("v", "<Leader>H", "<cmd>HopChar2BC<CR>", { noremap = false })

-- nvim-surround
vim.api.nvim_set_keymap("n", "<Leader>lw", "ysiw", { noremap = false })
vim.api.nvim_set_keymap("n", "<Leader>lW", "ysiW", { noremap = false })
vim.api.nvim_set_keymap("n", "<Leader>la", "ysa", { noremap = false })
vim.api.nvim_set_keymap("n", "<Leader>ll", "yss", { noremap = false })

-- nvim-spider
vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })

vim.keymap.set({ "n", "v" }, "<Leader>w", function()
  local Flash = require("flash")
  Flash.jump({
    search = { mode = "search" },
    label = {
      after = false,
      before = { 0, 0 },
      uppercase = false,
      format = function(opts)
        return {
          { opts.match.label1, "FlashLabel" },
          { opts.match.label2, "Comment" },
        }
      end,
    },
    pattern = [[\<]],
    action = function(match, state)
      state:hide()
      Flash.jump({
        search = { max_length = 0 },
        highlight = { matches = false },
        label = {
          after = false,
          before = { 0, 0 },
          format = function(opts)
            return {
              { opts.match.label1, "Comment" },
              { opts.match.label2, "FlashMatch" },
            }
          end,
        },
        matcher = function(win)
          -- limit matches to the current label
          return vim.tbl_filter(function(m)
            return m.label == match.label and m.win == win
          end, state.results)
        end,
        labeler = function(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2 -- use the second label
          end
        end,
      })
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  })
end, { noremap = true, desc = "Hop next words" })
