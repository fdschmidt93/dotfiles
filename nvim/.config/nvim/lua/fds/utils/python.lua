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

local function get_term_buf()
  local buf = vim.tbl_filter(function(buf)
    return vim.bo[buf].buftype == "terminal"
  end, vim.api.nvim_list_bufs())
  if #buf > 1 then
    print "Too many terminals open"
    return
  end
  return buf[1]
end

-- WIP
M.send_to_ipython = function(job_id, data)
  if job_id == nil then
    -- find unique term buf
    local buf = get_term_buf()
    if not buf then
      return
    end
    job_id = vim.b[buf].terminal_job_id
  end
  local header = "cpaste -q\n"
  api.nvim_chan_send(job_id, header)
  vim.wait(50) -- cpaste otherwise doesn't properly work
  api.nvim_chan_send(job_id, data .. "\n--\n")
end

-- WIP
M.inspect_python_var = function()
  local variable = vim.fn.expand "<cword>"
  print(variable)
  M.send_to_ipython(
    nil,
    string.format([[print(%s.shape if hasattr(%s, "shape") else len(%s));]], variable, variable, variable)
  )
  local buf = get_term_buf()
  local line_count = api.nvim_buf_line_count(buf)
  local winid = vim.tbl_filter(function(win)
    return api.nvim_win_get_buf(win) == buf
  end, api.nvim_list_wins())[1]
  api.nvim_win_set_cursor(winid, { line_count, 0 })
end

function M.init_repl()
  local repl = require "fds.utils.repl"
  local termbuf = repl.shell(repl.conda_env_prefix "ipython", "below", false)
  repl.toggle_termwin("below", termbuf)
end

api.nvim_create_autocmd("FileType", { pattern = "python", once = true, callback = M.init_repl })

-- open unlisted toggleable terminal automatically upon entering python
-- vim.cmd [[
--   autocmd FileType python ++once lua
--   autocmd FileType python lua require'fds.utils.repl'.set_slime_config()
-- ]]

return M
