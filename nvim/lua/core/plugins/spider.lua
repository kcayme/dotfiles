return {
  {
    "chrisgrieser/nvim-spider",
    lazy = true,
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = true,
        subwordMovement = true,
        customPatterns = {}, -- check Custom Movement Patterns for details
      })
    end,
  },
}
