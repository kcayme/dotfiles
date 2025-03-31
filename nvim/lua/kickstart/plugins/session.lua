return {
  {
    -- "rmagatti/auto-session",
    "cameronr/auto-session",
    -- branch = "[restore-error-handler](https://github.com/cameronr/auto-session/compare/restore-error-handler)",
    branch = "restore-error-handler",
    config = function()
      require("auto-session").setup({
        log_level = "error",
        --auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      })
    end,
  },
}
