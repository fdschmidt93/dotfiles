local api = vim.api

local M = {}

function M.buffer_is_terminal(buf) return string.find(buf.name, "term://") end

function M.get_listed_buffers()
  local listed_bufs = {}
  local all_bufs = vim.fn.getbufinfo()
  for _, buf in pairs(all_bufs) do
    if buf.listed == 1 then table.insert(listed_bufs, buf) end
  end
  return listed_bufs
end

local function launch_conda_env()
  local conda_env = os.getenv('CONDA_PROMPT_MODIFIER')
  conda_env = conda_env and conda_env:sub(2, -3) or 'base'
  return 'conda activate ' .. conda_env .. ' && '
end

function M.buf_name_contains(substring)
  local windows = api.nvim_tabpage_list_wins(0)
  for _, win in pairs(windows) do
    local buf_nr = api.nvim_win_get_buf(win)
    local buf_name = api.nvim_buf_get_name(buf_nr)
    if buf_name:find(substring) then return win, buf_nr, buf_name end
  end
end

-- function M.toggle_term()
--   local win, buf_nr, buf_name = M.buf_name_contains($SHELL)
--   local width = api.nvim_win_get_width(win)
--   local height = api.nvim_win_get_height(win)
-- end

-- (re-)starts ipython
function M.re_start_ipython(side, command)
  -- current window to return to
  local cur_win = api.nvim_get_current_win()
  local cur_buf = api.nvim_get_current_buf()

  local win, buf_nr, buf_name = M.buf_name_contains('ipython')
  if win ~= nil then
    -- create new buf
    local new_buf = api.nvim_create_buf(true, false)
    api.nvim_set_current_win(win)
    api.nvim_set_current_buf(new_buf)
    -- get command
    local strings = vim.split(buf_name, ':')
    local command
    for _, s in pairs(strings) do command = s end
    -- open terminal
    api.nvim_call_function('termopen', {command})

    -- set vim-slime config
    local term_id = vim.b.terminal_job_id
    local cfg = {}
    cfg['jobid'] = term_id
    vim.b.slime_config = cfg
    -- set new terminal buf to window
    api.nvim_win_set_buf(win, new_buf)
    -- kill old buf
    api.nvim_buf_delete(buf_nr, {force = true})
    -- return to current window
    api.nvim_set_current_win(cur_win)

    -- set slime variables
    local bufs = M.get_listed_buffers()
    for _, buf in pairs(bufs) do
      api.nvim_buf_set_var(buf.bufnr, 'slime_config', cfg)
    end
  else
    M.shell(side, command)
  end
end

function M.shell(side, command)
  side = side or 'right' -- default to 'right'

  if command ~= nil and string.find(command, 'python') then
    command = launch_conda_env() .. command
  end

  if side == 'below' then
    api.nvim_command('botright split new') -- split a new window
    api.nvim_win_set_height(0, 10) -- set the window height
  elseif side == 'right' then
    api.nvim_command('botright vsplit new') -- split a new window
  end
  -- run your stuff here, could be anything
  if command == nil then
    api.nvim_call_function('termopen', {'$SHELL'})
  else
    command = "$SHELL -C '" .. command .. "'"
    api.nvim_call_function('termopen', {command})
  end
  local term_id = vim.b.terminal_job_id
  api.nvim_command('wincmd p') -- go back to previous window
  local cfg = {}
  cfg['jobid'] = term_id
  -- apply config to all
  local bufs = M.get_listed_buffers()
  for _, buf in pairs(bufs) do
    api.nvim_buf_set_var(buf.bufnr, 'slime_config', cfg)
  end
  vim.b.slime_config = cfg
end

return M
