local M = {}
local api = vim.api
local HOME = vim.loop.os_homedir()

M.use_local = function(path, fallback, opts)
  opts = opts or {}
  if path:sub(1, 1) == "~" then
    path = HOME .. path:sub(2, -1)
  end
  if vim.fn.isdirectory(path) == 1 then
    opts.dir = path
  else
    opts[1] = fallback
  end
  return opts
end

-- neither wqa nor wqa! work nicely with terminal buffer opened
M.write_close_all = function()
  vim.cmd [[wa!]]
  vim.cmd [[qa!]]
end

M.get_selection = function()
  local rv = vim.fn.getreg '"'
  local rt = vim.fn.getregtype '"'
  local mode = vim.api.nvim_get_mode().mode
  local cmd
  if mode == "v" then
    cmd = "normal! `<v`>y"
  elseif mode == "V" then
    cmd = "normal! '[V']y"
  elseif mode == "" then
    cmd = [[normal! `[\<C-V>`]\y]]
  end
  vim.cmd(string.format([[noautocmd silent exe "%s"]], cmd))
  local selection = vim.fn.getreg '"'
  vim.pretty_print(selection)
  vim.fn.setreg('"', rv, rt)
  return ret
end

M.hl_lines = function(expr, opts)
  opts = opts or {}
  opts.hl_group = vim.F.if_nil(opts.hl_group, "CursorLine")
  local lines = api.nvim_buf_get_lines(0, 0, -1, false)
  local ns = api.nvim_create_namespace "HLLINES"
  for i, line in ipairs(lines) do
    if string.match(line, expr) then
      api.nvim_buf_set_extmark(
        0,
        ns,
        i - 1,
        0,
        { end_row = i, hl_eol = true, hl_group = opts.hl_group, hl_mode = "replace" }
      )
    end
  end
end

M.clear_hl_lines = function()
  local ns = api.nvim_create_namespace "HLLINES"
  api.nvim_buf_clear_namespace(0, ns, 0, -1)
end

M.toggle_qf = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd "cclose"
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd "copen"
  end
end

-- expand or minimize current buffer in "actual" direction
-- this is useful as mapping ":resize 2" stand-alone might otherwise not be in the right direction if mapped to ctrl-leftarrow or something related
-- use like this
M.resize = function(vertical, margin)
  local cur_win = vim.api.nvim_get_current_win()
  -- go (possibly) right
  vim.cmd(string.format("wincmd %s", vertical and "l" or "j"))
  local new_win = vim.api.nvim_get_current_win()

  -- determine direction cond on increase and existing right-hand buffer
  local not_last = not (cur_win == new_win)
  local sign = margin > 0
  -- go to previous window if required otherwise flip sign
  if not_last == true then
    vim.cmd [[wincmd p]]
  else
    sign = not sign
  end

  sign = sign and "+" or "-"
  local dir = vertical and "vertical " or ""
  local cmd = dir .. "resize " .. sign .. math.abs(margin) .. "<CR>"
  vim.cmd(cmd)
end

-- tmux like <C-b>z: focus on one buffer in extra tab
-- put current window in new tab with cursor restored
M.tabedit = function()
  -- skip if there is only one window open
  if vim.tbl_count(vim.api.nvim_tabpage_list_wins(0)) == 1 then
    print "Cannot expand single buffer"
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local view = vim.fn.winsaveview()
  -- note: tabedit % does not properly work with terminal buffer
  vim.cmd [[tabedit]]
  -- set buffer and remove one opened by tabedit
  local tabedit_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_delete(tabedit_buf, { force = true })
  -- restore original view
  vim.fn.winrestview(view)
end

-- restore old view with cursor retained
M.tabclose = function()
  local buf = vim.api.nvim_get_current_buf()
  local view = vim.fn.winsaveview()
  vim.cmd [[tabclose]]
  -- if we accidentally land somewhere else, do not restore
  local new_buf = vim.api.nvim_get_current_buf()
  if buf == new_buf then
    vim.fn.winrestview(view)
  end
end

return M
