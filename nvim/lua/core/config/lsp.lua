local base_capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
  textDocument = {
    semanticTokens = {
      multilineTokenSupport = true,
    },
  },
})

vim.lsp.config("*", {
  capabilities = base_capabilities,
  root_markers = { ".git" },
})

-- Re-apply with blink.cmp capabilities once it loads
vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpReady",
  once = true,
  callback = function()
    local capabilities = vim.tbl_deep_extend(
      "force",
      base_capabilities,
      require("blink.cmp").get_lsp_capabilities()
    )
    vim.lsp.config("*", {
      capabilities = capabilities,
      root_markers = { ".git" },
    })
  end,
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
