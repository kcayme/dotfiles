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
      },
    },
  },
}
