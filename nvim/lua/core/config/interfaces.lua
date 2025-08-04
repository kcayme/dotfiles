local picker = {
  backend = "fzf-lua",
  library = require("fzf-lua"),
}

picker.lsp_implementations = function(opts)
  local backend = picker.backend

  if backend == "fzf-lua" or backend == "snacks" then
    picker.library.lsp_implementations(opts)
  else
    error("Unsupported picker backend: " .. tostring(picker.engine))
  end
end

picker.lsp_type_definitions = function(opts)
  local backend = picker.backend

  if backend == "fzf-lua" then
    picker.library.lsp_typedefs(opts)
  elseif picker.backend == "snacks" then
    picker.library.lsp_type_definitions(opts)
  else
    error("Unsupported picker backend: " .. tostring(picker.engine))
  end
end

picker.lsp_symbols = function(opts)
  local backend = picker.backend

  if backend == "fzf-lua" then
    require(backend).lsp_document_symbols(opts)
  elseif picker.backend == "snacks" then
    require(backend).lsp_symbols(opts)
  else
    error("Unsupported picker backend: " .. tostring(picker.engine))
  end
end

picker.lsp_workspace_symbols = function(opts)
  local backend = picker.backend

  if backend == "fzf-lua" then
    require(backend).lsp_workspace_symbols(opts)
  elseif picker.backend == "snacks" then
    require(backend).lsp_workspace_symbols(opts)
  else
    error("Unsupported picker backend: " .. tostring(picker.engine))
  end
end

picker.lsp_declarations = function(opts)
  local backend = picker.backend

  if backend == "fzf-lua" or backend == "snacks" then
    require(backend).lsp_declarations(opts)
  else
    error("Unsupported picker backend: " .. tostring(picker.engine))
  end
end

picker.lsp_definitions = function(opts)
  local backend = picker.backend

  if backend == "fzf-lua" or backend == "snacks" then
    require(backend).lsp_definitions(opts)
  else
    error("Unsupported picker backend: " .. tostring(picker.engine))
  end
end

picker.lsp_references = function(opts)
  local backend = picker.backend

  if backend == "fzf-lua" or backend == "snacks" then
    require(backend).lsp_references(opts)
  else
    error("Unsupported picker backend: " .. tostring(picker.engine))
  end
end

return picker
