local picker = require("fzf-lua")

local fzf = {}

local picker_interface_methods = require("core.config.backends.common")

for _, method in ipairs(picker_interface_methods) do
  fzf[method] = function(opts)
    picker[method](opts)
  end
end

-- override for fzf-lua-specific methods
fzf.lsp_type_definitions = function(opts)
  picker.typedefs(opts)
end

fzf.lsp_symbols = function(opts)
  picker.lsp_document_symbols(opts)
end

fzf.lsp_workspace_symbols = function(opts)
  picker.lsp_workspace_symbols(opts)
end

fzf.grep = function(opts)
  picker.live_grep(opts)
end

fzf.grep_word = function(opts)
  picker.grep_cword(opts)
end

fzf.todo_comments = function(opts)
  vim.cmd("TodoFzfLua")
end

fzf.diagnostics = function(opts)
  picker.diagnostics_workspace(opts)
end

fzf.help = function(opts)
  picker.helptags(opts)
end

fzf.smart = function(opts)
  picker.frecency(opts)
end

fzf.global = function(opts)
  picker.global(opts)
end

return fzf
