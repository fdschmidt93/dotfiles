local condition = require('galaxyline.condition')

M = {}

M.has_file_type = function()
  if not vim.bo.filetype or vim.bo.filetype == "" then
    return false
  end
  return true
end

M.buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand "%:t") ~= 1 then
    return true
  end
  return false
end

M.git_condition = function()
  return condition.check_git_workspace() and M.buffer_not_empty() and M.has_file_type()
end

M.is_lsp_attached = function()
  return not vim.tbl_isempty(vim.lsp.buf_get_clients())
end

return M
