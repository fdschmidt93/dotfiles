local api = vim.api

local M = {}

local function fix_import_module_level(diagnostic)
  local modules = {}
  for match in string.gmatch(diagnostic.message, [["[%w%p]+"]]) do
    table.insert(modules, string.format(" %s ", match:sub(2, -2)))
  end
  local lnum = diagnostic.lnum
  local line = vim.api.nvim_buf_get_lines(diagnostic.bufnr, lnum, lnum + 1, false)[1]
  line = line:gsub(modules[2], modules[3])
  api.nvim_buf_set_lines(diagnostic.bufnr, lnum, lnum + 1, false, { line })
end

function M.fix_imports()
  local diagnostics = vim.diagnostic.get(0)

  local fix_import_path = vim.tbl_filter(function(d)
    return string.find(d.message, "is not exported from module")
  end, diagnostics)
  for _, diagnostic in ipairs(fix_import_path) do
    fix_import_module_level(diagnostic)
  end
end

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
  autocmd FileType python ++once lua require'fds.utils.repl'.shell(require'fds.utils.repl'.conda_env_prefix('ipython'), 'below', false)
  autocmd FileType python ++once lua require'fds.utils.repl'.toggle_termwin('below')
  autocmd FileType python lua require'fds.utils.repl'.set_slime_config()
]]

return M
