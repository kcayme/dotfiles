-- lsp setup with nvim defaults + overrides
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities({
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      },
    },
  }, true),
  root_markers = { ".git" },
})

-- toggle globally with :InlayHintToggle / :CodeLensToggle
vim.lsp.inlay_hint.enable(false)
vim.lsp.codelens.enable(false)

-- Code lens icons by title keyword, first match wins; lspkind where a completion kind fits
local kind = require("lspkind").symbol_map
local codelens_icons = {
  { "debug", "\u{eb91}" }, -- cod-debug_alt
  { "test", "\u{ea79}" }, -- cod-beaker
  { "reference", kind.Reference },
  { "implementation", kind.Interface },
  { "generate", "\u{eaf8}" }, -- cod-gear
  { "tidy", kind.Module },
  { "vendor", kind.Module },
  { "upgrade", kind.Module },
  { "dependenc", kind.Module },
  { "run", "\u{eb2c}" }, -- cod-play
}
local CodeLens = vim.lsp._capability.all.codelens
local codelens_on_win = CodeLens.on_win
-- shortcut: hooks the private 0.12 codelens draw (no display hook); recheck after Neovim upgrades
CodeLens.on_win = function(self, toprow, botrow)
  for _, state in pairs(self.client_state) do
    for row = toprow, botrow do
      local lenses = state.row_lenses[row] or {}
      -- drop "0 references" lenses; %f[%d] keeps "10 references"
      for i = #lenses, 1, -1 do
        if lenses[i].command and lenses[i].command.title:lower():find("%f[%d]0 reference") then
          table.remove(lenses, i)
        end
      end
      -- the native renderer indexes lenses[1] without checking for an empty row
      if #lenses == 0 then
        state.row_lenses[row] = nil
      end

      for _, lens in ipairs(lenses) do
        if lens.command and not lens.command.iconized then
          lens.command.iconized = true
          for _, icon in ipairs(codelens_icons) do
            if lens.command.title:lower():find(icon[1], 1, true) then
              lens.command.title = icon[2] .. " " .. lens.command.title
              break
            end
          end
        end
      end
    end
  end
  return codelens_on_win(self, toprow, botrow)
end

-- Re-apply lsp/*.lua configs via vim.lsp.config() so they take
-- priority over nvim-lspconfig defaults.
local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
for _, file in ipairs(vim.fn.glob(lsp_dir .. "/*.lua", false, true)) do
  local name = vim.fn.fnamemodify(file, ":t:r")
  local ok, config = pcall(dofile, file)
  if ok and type(config) == "table" and not vim.tbl_isempty(config) then
    vim.lsp.config(name, config)
  end
end
