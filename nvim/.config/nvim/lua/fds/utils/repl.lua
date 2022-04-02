-- wrappers around vim-slime
local api = vim.api

local function buf_is_term(buf)
  return vim.api.nvim_buf_get_option(buf, "buftype") == "terminal"
end

local M = {}

M.get_term_buf = function()
  return vim.tbl_filter(function(bufnr)
    return buf_is_term(bufnr)
  end, vim.api.nvim_list_bufs())
end

function M.shell(cmd, side, listed)
  listed = vim.F.if_nil(listed, true)
  side = side or "right" -- default to 'right'
  cmd = cmd and string.format('$SHELL -C "%s"', cmd) or "$SHELL"

  local cur_win = vim.api.nvim_get_current_win()
  if side == "below" then
    vim.cmd [[ botright split new]]
    api.nvim_win_set_height(0, 12) -- set the window height
  elseif side == "right" then
    vim.cmd [[ botright vsplit new ]]
  end

  local buf = vim.api.nvim_get_current_buf()
  local termbuf = vim.api.nvim_create_buf(listed, listed and true or false)
  vim.api.nvim_set_current_buf(termbuf)
  vim.api.nvim_buf_delete(buf, { force = true })
  vim.cmd [[set winhighlight=Normal:TelescopeNormal]]
  vim.fn.termopen(cmd)
  M.set_slime_config(vim.b.terminal_job_id)
  vim.api.nvim_set_current_win(cur_win)
  return termbuf
end

-- Apply slime config to all buffers
-- Assumes a single, unique repl instance
-- @param term_id number
M.set_slime_config = function(term_id)
  -- resolve with best effort
  if term_id == nil then
    -- find unique term buf
    local buf = vim.tbl_filter(buf_is_term, vim.api.nvim_list_bufs())
    if vim.tbl_isempty(buf) then
      return
    end
    if #buf > 1 then
      print "Too many terminals open"
      return
    end
    buf = buf[1]
    term_id = vim.api.nvim_buf_get_var(buf, "terminal_job_id")
  end
  vim.tbl_map(function(bufnr)
    if api.nvim_buf_is_loaded(bufnr) then
      api.nvim_buf_set_var(bufnr, "slime_config", { jobid = term_id })
    end
  end, vim.api.nvim_list_bufs())
end

M.conda_env_prefix = function(cmd)
  local conda_env = os.getenv "CONDA_PROMPT_MODIFIER"
  conda_env = conda_env and conda_env:sub(2, -3) or "base"
  return "conda activate " .. conda_env .. " && " .. cmd
end

M.toggle_termwin = function(side, buf)
  buf = vim.F.if_nil(buf, M.get_term_buf())
  local cur_win = vim.api.nvim_get_current_win()

  if type(buf) == "table" then
    if vim.tbl_isempty(buf) then
      print "No terminals yet open"
      return
    end
    if #buf > 1 then
      print "Too many terminal buffers open"
      return
    end
    buf = buf[1]
  end
  local win = vim.fn.win_findbuf(buf)
  if #win > 1 then
    print "Too many terminal windows open"
    return
  end
  win = win[1]
  if win == nil then
    if side == "right" then
      vim.cmd [[botright vsplit]]
    else
      vim.cmd [[botright split]]
      vim.api.nvim_win_set_height(0, 12)
    end
    vim.api.nvim_set_current_buf(buf)
    win = vim.api.nvim_get_current_win()
    M.set_slime_config(vim.b.terminal_job_id)
  else
    vim.api.nvim_win_close(win, true)
    win = nil
  end
  if win ~= cur_win then
    vim.api.nvim_set_current_win(cur_win)
  end
  return win
end

M.restart_term = function(cmd, side, listed)
  side = vim.F.if_nil(side, "right")
  listed = vim.F.if_nil(listed, true)

  local cur_win = api.nvim_get_current_win()
  local term_buf = vim.tbl_filter(function(buf)
    return string.find(vim.api.nvim_buf_get_name(buf), cmd)
  end, M.get_term_buf())
  if #term_buf > 1 then
    print "Too many terminals open"
  end
  term_buf = term_buf[1]

  -- find term buf, if nil create shell
  -- local win, buf_nr, buf_name = M.term_contains_cmd(cmd, side)
  if term_buf ~= nil then
    -- create new buf and assume window
    local new_termbuf = api.nvim_create_buf(listed, listed and true or false)
    local term_win = vim.fn.win_findbuf(term_buf)[1]
    if term_win == nil then
      term_win = M.toggle_termwin(side, term_win)
    end
    api.nvim_win_set_buf(term_win, new_termbuf)
    api.nvim_set_current_win(term_win)

    -- get command and open new terminal buffer in termwin
    local term_buf_name = vim.api.nvim_buf_get_name(term_buf)
    local term_cmd = table.remove(vim.split(term_buf_name, ":"))
    vim.fn.termopen(term_cmd)

    -- kill old buf
    api.nvim_buf_delete(term_buf, { force = true })

    -- apply config
    local term_id = api.nvim_buf_get_var(new_termbuf, "terminal_job_id")
    M.set_slime_config(term_id)
    api.nvim_set_current_win(cur_win)
  else
    M.shell(cmd, side, listed)
  end
end

return M
