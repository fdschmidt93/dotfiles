local lsp = vim.lsp

local M = {}

local get_nvim_lsp_diagnostic = function(diag_type, icon)
  if next(lsp.buf_get_clients(0)) == nil then
    return ""
  end
  local active_clients = lsp.get_active_clients()

  if active_clients then
    local count = 0

    for _, client in ipairs(active_clients) do
      count = count + lsp.diagnostic.get_count(vim.api.nvim_get_current_buf(), diag_type, client.id)
    end
    if count == 0 then
      return ""
    end
    return string.format("  %s %s", icon, count)
  end
end

local display_diagnostics = function()
  local error = get_nvim_lsp_diagnostic("Error", "")
  local warn = get_nvim_lsp_diagnostic("Warning", "")
  local info = get_nvim_lsp_diagnostic("Information", "I")
  local diag_ns = vim.api.nvim_create_namespace "diagnostics"
  vim.api.nvim_buf_set_extmark(0, diag_ns, 3, 1, {
    virt_text = {
      { error, "LspDiagnosticsDefaultError" },
      { warn, "LspDiagnosticsDefaultWarning" },
      { info, "LspDiagnosticsDefaultInformation" },
    },
    virt_text_pos = "right_align",
  })
end
