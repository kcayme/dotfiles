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
