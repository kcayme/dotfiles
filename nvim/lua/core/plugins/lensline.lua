return {
  "oribarilan/lensline.nvim",
  tag = "2.0.0", -- or: branch = 'release/2.x' for latest non-breaking updates
  event = "LspAttach",
  config = function()
    require("lensline").setup({
      profiles = {
        {
          name = "default",
          providers = { -- Array format: order determines display sequence
            {
              name = "last_author",
              enabled = true, -- enabled by default with caching optimization
              cache_max_files = 50, -- maximum number of files to cache blame data for (default: 50)
            },

            -- built-in providers that are diabled by default:
            {
              name = "diagnostics",
              enabled = true, -- disabled by default - enable explicitly to use
              min_level = "WARN", -- only show WARN and ERROR by default (HINT, INFO, WARN, ERROR)
            },
            {
              name = "complexity",
              enabled = false, -- disabled by default - enable explicitly to use
              min_level = "L", -- only show L (Large) and XL (Extra Large) complexity by default
            },

            -- custom providers
            {
              name = "references_with_warning",
              enabled = true,
              event = { "LspAttach", "BufWritePost" },
              handler = function(bufnr, func_info, provider_config, callback)
                local utils = require("lensline.utils")

                utils.get_lsp_references(bufnr, func_info, function(references)
                  if references then
                    local count = #references
                    local icon, text

                    if count == 0 then
                      icon = utils.if_nerdfont_else("⚠️ ", "WARN ")
                      text = icon .. "No references"
                    else
                      icon = utils.if_nerdfont_else("󰌹 ", "")
                      local suffix = utils.if_nerdfont_else("", " refs")
                      text = icon .. count .. suffix
                    end

                    callback({ line = func_info.line, text = text })
                  else
                    callback(nil)
                  end
                end)
              end,
            },
          },
          style = {
            placement = "inline",
            render = "focused", -- or "all" for showing lenses in all functions
            prefix = "",
            separator = " • ", -- separator between all lens attributes
            highlight = "Comment", -- highlight group for lens text
            -- prefix = "┃ ", -- prefix before lens content
            use_nerdfont = true, -- enable nerd font icons in built-in providers
          },
        },
      },
      limits = {
        exclude = {
          -- see config.lua for extensive list of default patterns
        },
        exclude_gitignored = true, -- respect .gitignore by not processing ignored files
        max_lines = 1000, -- process only first N lines of large files
        max_lenses = 70, -- skip rendering if too many lenses generated
      },
      debounce_ms = 300, -- unified debounce delay for all providers
      debug_mode = false, -- enable debug output for development, see CONTRIBUTE.md
    })
  end,
}
