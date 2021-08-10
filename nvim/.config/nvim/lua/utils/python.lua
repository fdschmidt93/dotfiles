local api = vim.api

local M = {}

function M.jump_to_ipy_error()
  local line = api.nvim_get_current_line()

  local filename = string.match(line, [["([^"]+)]])
  local buf_linenr = tonumber(string.match(line, [[line (%d+)]]))
  -- this relies on LSP having opened buffer; fallback to just opening the file
  local buffers = api.nvim_list_bufs()
  local bufnr
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_get_name(buf) == filename then
      bufnr = buf
      break
    end
  end
  if bufnr == nil then
    vim.cmd("edit " .. filename)
  else
    api.nvim_win_set_buf(0, bufnr)
  end
  api.nvim_win_set_cursor(0, { buf_linenr, 0 })
end


-- open unlisted toggleable terminal automatically upon entering python
vim.cmd [[
  autocmd FileType python ++once lua require'utils.repl'.shell(require'utils.repl'.conda_env_prefix('ipython'), 'below', false)
  autocmd FileType python ++once lua require'utils.repl'.toggle_termwin('below')
  autocmd FileType python lua require'utils.repl'.set_slime_config()
]]

return M
