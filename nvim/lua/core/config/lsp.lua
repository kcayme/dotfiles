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

local vue_language_server_path = vim.fn.expand("$MASON/packages")
  .. "/vue-language-server"
  .. "/node_modules/@vue/language-server"

local tsserver_filetypes = {
  "typescript",
  "javascript",
  "javascriptreact",
  "typescriptreact",
  "vue",
}
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}
local vtsls_config = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = tsserver_filetypes,
}

vim.lsp.config("vtsls", vtsls_config)

vim.lsp.config("*", {
  capabilities = capabilities,
  root_markers = { ".git" },
})

-- <rtp>/lsp/postgres_lsp.lua doesn't seem to work
vim.lsp.config("postgres_lsp", {
  cmd = { "postgres-language-server", "lsp-proxy" },
  filetypes = { "sql" },
  root_markers = { "postgres-language-server.jsonc", ".git" },
  workspace_required = false,
})
