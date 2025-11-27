return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        reportMissingImports = "error",
        reportMissingTypeStubs = "warning",
        diagnosticSeverityOverrides = {
          reportExplicitAny = "none",
          reportImplicitOverride = "none",
        },
        stubPath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "python-type-stubs"),
      },
    },
  },
}
