return {
    "karb94/neoscroll.nvim",
    config = function()
        require('neoscroll').setup({
            mappings = { '<C-u>', '<C-d>' },
            respect_scrolloff = true
        })
    end
}
