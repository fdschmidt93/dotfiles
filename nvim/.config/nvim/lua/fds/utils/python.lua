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

-- WIP
M.send_to_ipython = function(job_id, data)
  local header = "cpaste -q\n"
  api.nvim_chan_send(job_id, header)
  vim.wait(50) -- cpaste otherwise doesn't properly work
  api.nvim_chan_send(job_id, data .. "\n--\n")
end

-- WIP
M.inspect_python_var = function()
  local mode = vim.api.nvim_get_mode().mode
  local variable = vim.fn.expand "<cword>"
  M.send_to_ipython(316, string.format([[print(%s.shape if not hasattr(%s, "shape") else len(%s));]], variable))
  local line_count = api.nvim_buf_line_count(api.nvim_win_get_buf(1702))
  api.nvim_win_set_cursor(1702, { line_count, 0 })
end

function M.init_repl()
  local repl = require "fds.utils.repl"
  local termbuf = repl.shell(repl.conda_env_prefix "ipython", "below", false)
  repl.toggle_termwin("below", termbuf)
end

api.nvim_create_autocmd("FileType", { pattern = "python", once = true, callback = M.init_repl })
api.nvim_create_autocmd("FileType", { pattern = "python", callback = require("fds.utils.repl").set_slime_config })

-- open unlisted toggleable terminal automatically upon entering python
-- vim.cmd [[
--   autocmd FileType python ++once lua
--   autocmd FileType python lua require'fds.utils.repl'.set_slime_config()
-- ]]

return M
