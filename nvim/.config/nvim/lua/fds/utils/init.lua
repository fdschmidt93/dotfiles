local M = {}
local api = vim.api

-- neither wqa nor wqa! work nicely with terminal buffer opened
M.write_close_all = function()
  vim.cmd [[wa!]]
  vim.cmd [[qa!]]
end

M.get_selection = function()
  local rv = vim.fn.getreg "v"
  local rt = vim.fn.getregtype "v"
  vim.cmd [[noautocmd silent normal! "vy]]
  local selection = vim.fn.getreg "v"
  vim.fn.setreg("v", rv, rt)
  return vim.split(selection, "\n")
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

--- Resizes the current buffer in the specified direction by the given margin.
--- The function conceptually works by first determining the direction of expansion or
--- contraction (left/right for vertical, up/down for horizontal). It then attempts to
--- move the window cursor to resize the current window. If the window cursor doesn't
--- move, it means we're at the edge and thus it resizes in the opposite direction.
---@param vertical boolean: If `true`, resize vertically, else horizontally.
---@param margin integer: The integer of lines or columns to resize by.
M.resize = function(vertical, margin)
  -- Constants for window commands
  local WINCMD_LEFT = "l"
  local WINCMD_DOWN = "j"
  local WINCMD_PREVIOUS = "p"

  -- Get the current active window.
  local current_window = vim.api.nvim_get_current_win()

  -- Move the cursor to the adjacent window in the specified direction.
  local direction = vertical and WINCMD_LEFT or WINCMD_DOWN
  vim.cmd("wincmd " .. direction)

  -- Get the new active window after the cursor move.
  local new_winind = vim.api.nvim_get_current_win()

  -- If we're not at the last window, we'll have switched windows; otherwise, we'll invert the resize direction.
  local expand_window = (current_window ~= new_winind)
  if not expand_window then
    -- If we didn't switch windows, invert the margin to shrink the current window.
    margin = -margin
  else
    -- Move back to the original window.
    vim.cmd("wincmd " .. WINCMD_PREVIOUS)
  end

  -- Construct the resize command based on the direction and margin.
  local resize_sign = (margin > 0) and "+" or "-"
  local resize_direction = vertical and "vertical " or ""
  local resize_command = resize_direction .. "resize " .. resize_sign .. math.abs(margin)

  vim.cmd(resize_command)
end

-- tmux like <C-b>z: focus on one buffer in extra tab
-- put current window in new tab with cursor restored
M.tabedit = function()
  -- skip if there is only one window open
  if vim.tbl_count(vim.api.nvim_tabpage_list_wins(0)) == 1 then
    vim.notify("Cannot expand single buffer", vim.log.levels.WARN)
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
