local lsp = vim.lsp

lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
  underline = false, -- disable virtual text
  virtual_text = false,
  -- show signs
  signs = true,
  -- delay update diagnostics
  update_in_insert = false,
})

lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
  border = "rounded",
})

lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
  border = "rounded",
})

local signs = { "", "", "", "" }
local diagnostic_types = { "Error", "Warning", "Information", "Hint" }

for i = 1, #diagnostic_types do
  local diagnostic_type = string.format("LspDiagnosticsSign%s", diagnostic_types[i])
  local opts = {
    text = signs[i],
    texthl = diagnostic_type,
    linehl = "",
    numhl = "",
  }
  vim.fn.sign_define(diagnostic_type, opts)
end
