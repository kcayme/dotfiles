local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(capabilities))

-- merge custom capabilities
capabilities = vim.tbl_deep_extend("force", capabilities, {
  textDocument = {
    semanticTokens = {
      multilineTokenSupport = true,
    },
  },
})

vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { ".git" },
})

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
