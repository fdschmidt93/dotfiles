local api = vim.api

local M = {}

local function get_terminal_buffers()
  return vim.tbl_filter(function(bufnr)
    return vim.bo[bufnr].buftype == "terminal"
  end, api.nvim_list_bufs())
end

local function open_term_split(side)
  local original_winid = api.nvim_get_current_win()
  if side == "below" then
    vim.cmd [[ botright split new]]
    api.nvim_win_set_height(0, 12) -- set the window height
  else
    vim.cmd [[ botright vsplit new ]]
  end
  local new_winid = api.nvim_get_current_win()
  local new_bufnr = api.nvim_win_get_buf(new_winid)
  api.nvim_win_call(new_winid, function()
    vim.cmd [[set winhighlight=Normal:TelescopeNormal]]
  end)
  api.nvim_set_current_win(original_winid)
  return { bufnr = new_bufnr, winid = new_winid }
end

-- Open a (fish-)shell in a new win-split with opts.
-- @param opts table
-- @field cmd string: cmd to open shell with
-- @field side string: side to open shell on ("right" or "below")
-- @field listed boolean: whether terminal buffer is listed (default: true)
function M.shell(opts)
  opts = opts or {}
  opts.listed = vim.F.if_nil(opts.listed, true)
  opts.side = vim.F.if_nil(opts.side, "right") -- default to 'right'
  opts.cmd = opts.cmd and string.format('$SHELL -C "%s"', opts.cmd) or "$SHELL"

  local split = open_term_split(opts.side)
  if not opts.listed then
    vim.bo[split.bufnr].buflisted = false
  end
  api.nvim_buf_call(split.bufnr, function()
    vim.fn.termopen(opts.cmd)
  end)
  return split
end

-- Ensure cmd is launched in appropriate conda environment (eg remote tmux).
M.wrap_conda_env = function(cmd)
  local conda_env = os.getenv "CONDA_PROMPT_MODIFIER"
  conda_env = conda_env and conda_env:sub(2, -3) or "base"
  return "conda activate " .. conda_env .. " && " .. cmd
end

-- Toggle single existing terminal window.
-- Note:
--  - Does nothing if more than one terminal buffer or window exists,
-- @param side string: side to open terminal on (one of "right", "below")
-- @param opts table
-- @field bufnr number: optional bufnr to pass, otherwise deduced
function M.toggle_termwin(side, opts)
  opts = opts or {}
  if opts.bufnr == nil then
    local termbufs = get_terminal_buffers()
    if vim.tbl_isempty(termbufs) then
      print "No terminals yet open"
      return
    end
    if #termbufs > 1 then
      print "Too many terminal buffers open"
      return
    end
    opts.bufnr = termbufs[1]
  end

  local cur_win = api.nvim_get_current_win()
  local winid = vim.fn.win_findbuf(opts.bufnr)
  if #winid > 1 then
    print "Too many terminal windows open"
    return
  end
  winid = winid[1]
  if winid == nil then
    local split = open_term_split(side)
    api.nvim_win_set_buf(split.winid, opts.bufnr)
    api.nvim_buf_delete(split.bufnr, { force = true })
  else
    api.nvim_win_close(winid, true)
    winid = nil
  end
  if winid ~= cur_win then
    api.nvim_set_current_win(cur_win)
  end
  return winid
end

-- Starts or restarts a termbuf launched comprising `cmd`
-- - Note:
--      - cmd is found in the name of the terminal buffer
-- @param cmd string: command to (re-)start shell with
-- @param opts table
-- @field side string: side to open terminal on (one of "right", "below")
-- @field listed boolean: whether terminal buffer is listed or not
function M.restart_term(cmd, opts)
  opts = opts or {}
  opts.side = vim.F.if_nil(opts.side, "right")
  opts.listed = vim.F.if_nil(opts.listed, true)
  local term_buf = vim.tbl_filter(function(buf)
    return string.find(api.nvim_buf_get_name(buf), cmd)
  end, get_terminal_buffers())
  if #term_buf > 1 then
    print "Too many terminals open"
  end
  term_buf = term_buf[1]

  if term_buf ~= nil then
    opts.listed = vim.bo[term_buf].buflisted
    local new_termbuf = api.nvim_create_buf(opts.listed, opts.listed and true or false)
    local winid = vim.fn.win_findbuf(term_buf)

    -- get command and open new terminal buffer in termwin
    local term_buf_name = api.nvim_buf_get_name(term_buf)
    local term_cmd = table.remove(vim.split(term_buf_name, ":"))
    vim.api.nvim_buf_call(new_termbuf, function()
      vim.fn.termopen(term_cmd)
    end)

    for _, win in ipairs(winid) do
      api.nvim_win_set_buf(win, new_termbuf)
    end
    api.nvim_buf_delete(term_buf, { force = true })
  else
    opts.cmd = cmd
    M.shell(opts)
  end
end

return M
