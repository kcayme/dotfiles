return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "standard",
        autoImportCompletions = true,
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
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
