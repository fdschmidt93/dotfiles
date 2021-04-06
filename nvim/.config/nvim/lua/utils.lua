local M = {}
local api = vim.api

-- test strings for visual selection
-- of PR for neovim core
local a = '全ä'
local c = 'ä anda α'
local b = '全角全角全角'
local d = 'hallääääääääää'

M.set_hl = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui
  local link = options.link or false
  local target = options.target

  if not link then
    vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
  else
    vim.cmd(string.format('hi! link', group, target))
  end
end



M.resize = function(vertical, margin)
  local cur_win = vim.api.nvim_get_current_win()
  -- go (possibly) right
  vim.cmd(string.format('wincmd %s', vertical and 'l' or 'j'))
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

  sign = sign and '+' or '-'
  local dir = vertical and 'vertical ' or ''
  local cmd = dir .. 'resize ' .. sign .. math.abs(margin) .. '<CR>'
  vim.cmd(cmd)
end

-- use quickfix window in combination with telescope
-- telescope: <C-q> sends items to quickfix list for later use
M.toggle_qf = function()
  local windows = vim.fn.getwininfo()
  local qf_exists = false
  for _, win in pairs(windows) do
    if win['quickfix'] == 1 then qf_exists = true end
  end
  local qf_toggle = not qf_exists and 'copen' or 'cclose'
  vim.cmd(qf_toggle)
end

-- local mode = {'c', 'l', 'b'}

function M.convert_reg_to_pos(reg1, reg2)
  -- get {start: 'v', end: curpos} of visual selection 0-indexed
  local pos1 = vim.fn.getpos(reg1)
  local pos2 = vim.fn.getpos(reg2)
  -- (0, 1)-indexed
  return {pos1[2] - 1, pos1[3] + pos1[4]}, {pos2[2] - 1, pos2[3] + pos2[4]}
end

-- Get position for passed registers
-- @param start_register table see help :getpos
-- @param end_register table see help :getpos
-- @param exit_visual_mode boolean whether to exit visual mode
function M.adjust_pos_by_regtype(pos1, pos2, mode)
  mode = vim.F.if_nil(mode, 'c')
  local line1, col1 = unpack(pos1)
  local line2, col2 = unpack(pos2)

  -- Resolution via wincol (see :help wincol) enables reengineering of blockwise selection
  local wincol_pos
  if mode == '' then
    -- get wincol for (1, 0)-indexed position

    local wincol1 = M.get_wincol({line1 + 1, col1 - 1})
    local wincol2 = M.get_wincol({line2 + 1, col2 - 1})
    P({wincol1, wincol2})
    -- Blockwise selection requires the very most edge wincol
    -- Consider a multi-width char: 全, wincol solely returns the first visual column though char occupies 2 cols
    -- get edge pos for wincol start (most left) and end (most right) by line from original positions
    local line_flip = line1 > line2
    local col_flip = col1 > col2
    wincol1 = M.resolve_wincol(wincol1, {line1 + 1, col1 - 1}, col_flip)
    wincol2 = M.resolve_wincol(wincol2, {line2 + 1, col2 - 1}, not col_flip)
    P({wincol1, wincol2})

    if line_flip then line1, line2 = line2, line1 end
    if col_flip then
      col1, col2 = col2, col1
      wincol1, wincol2 = wincol2, wincol1
    end

    pos1 = {line1, col1}
    pos2 = {line2, col2}
    wincol_pos = {wincol1, wincol2}
  else
    -- char- or linewise selection
    if (line1 == line2 and col2 < col1) or line1 > line2 then
      pos1, pos2 = pos2, pos1
    end
  end
  return pos1, pos2, wincol_pos
end

-- Retrieve wincol from pos
-- wincol (see :help wincol) denotes the visual column of the current cursor position
-- Since wincol can only be retrieved for the current position,
-- the cursor has to be set prior
-- @param pos table (1, 0)-indexed cursor position get the wincol for
function M.get_wincol(pos)
  -- get start position
  local start_pos = api.nvim_win_get_cursor(0)

  -- get wincol for actual position
  vim.api.nvim_win_set_cursor(0, pos)
  local wincol = vim.fn.wincol()

  -- return to start position
  vim.api.nvim_win_set_cursor(0, start_pos)
  return wincol
end

-- Get maximum, possibly synthetic wincol for position
-- Consider a multi-width char: 全, wincol solely returns the first visual column
-- edge_wincol returns the left or right border wincol instead depending on parameters
-- @param pos table {row, column} with {1, 0} indexed values
-- @param wincol integer initial wincol prior to finding (synthetic) minimum or maximum
-- @param maximum boolean true resolves towards right, false resolves towards left
function M.resolve_wincol(wincol, pos, right, allow_overhang)
  allow_overhang = vim.F.if_nil(allow_overhang, true)
  right = vim.F.if_nil(right, false)
  local max_col = M.get_wincol({pos[1], 2 ^ 31 - 1})

  if wincol == 1 and not right then return 1 end

  local newcol = M.get_wincol(pos)
  if right then
    if wincol == max_col then
      if allow_overhang then
        local line = api.nvim_buf_get_lines(0, pos[1] - 1, pos[1], false)[1]
        max_col = max_col + pos[2] + 1 - #line
      end
      return max_col
    end
    if newcol > wincol then
      return newcol - 1
    else
      return M.resolve_wincol(wincol, {pos[1], pos[2] + 1}, true)
    end
  else
    if newcol < wincol then
      return newcol + 1
    elseif newcol == wincol then
      return wincol
    else
      return M.resolve_wincol(wincol, {pos[1], pos[2] - 1}, false)
    end
  end
end

-- Recursively resolve beginning or ending byte column for multi-width characters
--  Example: multi-width Japanese Zenkaku, see change in columns from left to right char
--  全角
-- For 全 above and offset=1, resolve_bytecol returns 7
-- vim.str_byteindex is similar though can only return the right-hand border
-- Note: byte columns are 1-indexed for simplified interop with lua string:sub
-- @param line string: buffer line
-- @param byte_col integer: initial byte column
-- @param offset integer: resolver char border towards char beginning (-1) or char end (+1)
-- return byte_col integer: byte column of char beginning or end
function M.edge_bytecol(line, byte_index, use_utf16)
  use_utf16 = vim.F.if_nil(use_utf16, false)
  local utf_col, _ = vim.str_utfindex(line, byte_index)
  -- convert utf to byte position for end index
  local byte_index_end = vim.str_byteindex(line, utf_col, use_utf16)

  -- determine first offset for which utf column changes
  local i = 1
  while byte_index ~= i do
    local utf_prev, _ = vim.str_utfindex(line, byte_index - i)
    if utf_prev ~= utf_col then break end
    i = i + 1
  end
  -- i as is represents first invalid offset, correct with - 1
  local byte_index_start = byte_index - (i - 1)
  return byte_index_start, byte_index_end
end

-- Greedily get closest byte column left {true} or right {left=false} from passed wincol
-- Once edge wincol for blockwise selection are found, this function finds
-- closest or match byte column in terms of starting pos and direction
-- Returns byte column zero indexed
-- Note: greedy resolution is performed as recursion would otherwise require difficult/opaque edge cases to catch
-- @param wincol integer wincol to get closest or equal byte column for
-- @param pos table {row and column} {1, 0}-index of position to resolve
-- @param line_len integer length of line in byte columns, zero-indexed (lua string length - 1)
-- @param left boolean approximate or match wincol from left (true, ~max) or from right (false, ~min)
function M.greedy_wincol_byte(wincol, pos, line_len, left)
  left = vim.F.if_nil(left, false)
  local max_col = M.get_wincol({pos[1], 2 ^ 31 - 1})

  if left then
    if wincol > max_col then return line_len end
    for i = 0, line_len do
      local wcol = M.get_wincol({pos[1], i})
      if wcol == wincol then return i end
      if wcol > wincol then return i - 1 end
    end
  else
    if wincol > max_col then return nil end
    for i = line_len, 0, -1 do
      local wcol = M.get_wincol({pos[1], i})
      if wcol <= wincol then return i end
    end

  end
end

function M.visual_selection()
  local mode = vim.api.nvim_get_mode().mode
  -- vim.cmd [[set virtualedit=onemore]]
  local pos1, pos2 = M.convert_reg_to_pos("v", ".")
  vim.cmd [[normal :esc<CR>]]
  P(M.region(0, pos1, pos2, mode, true))
  -- vim.cmd [[set virtualedit=""]]
end

function M.region(bufnr, pos1, pos2, regtype, inclusive)
  local delimiter = ' '
  local trim = true
  local wincol_pos
  pos1, pos2, wincol_pos = M.adjust_pos_by_regtype(pos1, pos2, regtype)
  -- P(pos1)
  -- P(pos2)
  local line1, col1 = unpack(pos1)
  local line2, col2 = unpack(pos2)
  local lines = vim.api.nvim_buf_get_lines(0, line1, line2 + 1, false)
  local concat = {}
  local first_line = 1
  local last_line = line2 - (line1 - 1)
  if first_line == last_line then
    -- get difference in columns, inclusive
    col2 = col2 - col1 + 1
  end
  for row = first_line, last_line do
    local line = lines[row]
    if line ~= "" then
      if regtype ~= 'V' then
        local start_bytecol
        if row == first_line or regtype == '' then
          if regtype == '' then
            -- Iterate from end of line to get maximum byte col for which wincol >= wincol_start
            start_bytecol = M.greedy_wincol_byte(wincol_pos[1],
            -- pass (1,0)-indexed pos
                                                 {line1 + row, col1 - 1},
                                                 #lines[row] - 1, false)
            -- wincol_start is beyond line
            if start_bytecol ~= nil then
              start_bytecol = start_bytecol + 1 -- add 1 to 1-index column
              start_bytecol, _ = M.edge_bytecol(line, start_bytecol)
            else
              start_bytecol = #line + 1 -- clear out line
            end

          else
            -- Recursively get first byte index of utf char for initial byte column selection
            --  Example: multi-width Japanese Zenkaku, see change in columns from left to right char
            --  全角
            start_bytecol, _ = M.edge_bytecol(line, col1)
          end
          line = line:sub(start_bytecol)
        end
        if row == last_line or regtype == '' and line ~= '' then
          local end_bytecol
          if regtype == '' then
            -- Iterate from beginning of line to get maximum byte col for which wincol <= wincol_end
            end_bytecol = M.greedy_wincol_byte(wincol_pos[2],
            -- pass (1,0)-indexed pos
                                               {line1 + row, col2 - 1},
                                               #lines[row] - 1, true) -- get difference in byte offset inclusive and add back zero indexing
            -- (difference here means absolute position after cutoff)
            - start_bytecol + 2
          end
          -- Recursively get last byte index of utf char for last byte column selection
          _, end_bytecol = M.edge_bytecol(line, end_bytecol or col2)
          line = line:sub(1, math.min(end_bytecol, #line))
        end
      end
    end
    if trim then line = vim.trim(line) end
    table.insert(concat, line)
  end
  return table.concat(concat, delimiter)
end

return M
