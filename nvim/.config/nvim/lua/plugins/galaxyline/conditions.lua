local condition = require "galaxyline.condition"

M = {}

M.git_condition = function()
  local has_filetype = type(vim.bo[0].filetype) == "string" and vim.bo[0].filetype ~= ""
  return condition.check_git_workspace() and condition.buffer_not_empty() and has_filetype
end

M.is_lsp_attached = function() return not vim.tbl_isempty(vim.lsp.get_clients()) end

return M
