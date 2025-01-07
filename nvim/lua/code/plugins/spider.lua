return {
  "chrisgrieser/nvim-spider",
  lazy = true,
  config = function(self, opts)
    require("spider").setup {
      skipInsignificantPunctuation = false,
      subwordMovement = true,
      customPatterns = {},   -- check Custom Movement Patterns for details
    }
  end
}
