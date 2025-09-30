local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
capabilities = vim.tbl_deep_extend(
  "force",
  capabilities,
  {}
  -- require("cmp_nvim_lsp").default_capabilities(capabilities),
  -- require("blink.cmp").get_lsp_capabilities(capabilities)
)

vim.lsp.config("*", {
  capabilities = capabilities,
})
