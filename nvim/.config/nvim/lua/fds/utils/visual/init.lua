-- trying full get_region support
-- if anyone who reads this ever figures it out, ping me ;)

local api = vim.api

local a = "全ä"

local c = "ä anda α"
local b = "全角全角全角"
local d = "hallääääääääää"

local M = {}

function M.convert_reg_to_pos(reg1, reg2)
  -- get {start: 'v', end: curpos} of visual selection 0-indexed
  local pos1 = vim.fn.getpos(reg1)
  local pos2 = vim.fn.getpos(reg2)
  -- (0, 1)-indexed
  return { pos1[2] - 1, pos1[3] + pos1[4] }, { pos2[2] - 1, pos2[3] + pos2[4] }
end

function M.get_wincol(win, pos)
  local cur_pos = api.nvim_win_get_cursor(win)
  api.nvim_win_set_cursor(win, pos)
  local wincol = vim.fn.wincol()
  api.nvim_win_set_cursor(win, cur_pos)
  return wincol
end

-- row needs to be 1-indexed
function M.get_max_wincol(win, row)
  local cur_pos = api.nvim_win_get_cursor(win)
  -- row 1-indexed
  vim.fn.cursor(row, 150)
  local new_pos = api.nvim_win_get_cursor(win)
  local pos = api.nvim_win_get_cursor(win)
  local wincol = M.get_wincol(win, new_pos)
  api.nvim_win_set_cursor(win, cur_pos)
  return wincol
end
-- row 0 indexed
function M.get_min_wincol(win)
  local cur_pos = api.nvim_win_get_cursor(win)
  -- row 1-indexed
  vim.fn.cursor(1, 1)
  local pos = api.nvim_win_get_cursor(win)
  local wincol = M.get_wincol(win, pos)
  api.nvim_win_set_cursor(win, cur_pos)
  return wincol
end

function M.convert_wincol_to_byteindex(win, row, wincol, last)
  -- row: (0, 1) indexed
  local buf = api.nvim_win_get_buf(win)
  -- row 0-indexed
  local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, true)[1]
  local len = #line
  if len == 0 then
    return 1, M.get_min_wincol(win)
  end
  -- (1, 0) indexed
  local max_wincol = M.get_max_wincol(win, row + 1)
  P { "row=", row, "wincol=", wincol, "max_wincol=", max_wincol }
  -- P { "win=", win, "row=", row, "max_wincol=", max_wincol}
  -- P { "row=", row, "len=", len, "line=", line, "max_wincol=", max_wincol }
  local byte_wincol
  -- find maximum byte index with same wincol
  if last then
    if max_wincol <= wincol then
      return len, max_wincol
    end
    for byte = len, 1, -1 do
      -- convert to (1, 0) indexing
      local byte_wincol = M.get_wincol(win, { row + 1, byte - 1 })

      if byte_wincol <= wincol then
        -- return byte 1-indexed
        return byte, byte_wincol
      end
      -- P {"last=",last, "byte=", byte, "byte_wincol=", byte_wincol, "wincol=", wincol, "bytechar=", line:sub(byte, byte) }
    end
  else
    for byte = 1, len do
      local byte_wincol = M.get_wincol(win, { row + 1, byte - 1 })
      P { "byte=", byte, "byte_wincol=", byte_wincol, "bytechar=", line:sub(byte, byte) }
      if byte_wincol == wincol then
        return byte, byte_wincol
      end
      if byte_wincol > wincol then
        return byte - 1, byte_wincol
      end
    end
  end
end

-- Get maximum, possibly synthetic wincol for position
-- Consider a multi-width char: 全, wincol solely returns the first visual column
-- edge_wincol returns the left or right border wincol instead depending on parameters
-- @param pos table {row, column} with {1, 0} indexed values
-- @param wincol integer initial wincol prior to finding (synthetic) minimum or maximum
-- @param maximum boolean true resolves towards right, false resolves towards left
-- function M.resolve_wincol(win, wincol, row, right)
--   local min_col = M.get_min_wincol(win)
--   local max_col = M.get_max_wincol(win, row)
--   if right then
--     if max_col >= wincol then
--       return max_col
--     end
-- end

function visual_selection()
  local mode = vim.api.nvim_get_mode().mode
  -- (0, 1)-indexed
  local pos1, pos2 = M.convert_reg_to_pos("v", ".")

  -- convert to (1, 0)-indexing
  local wincol1 = M.get_wincol(0, { pos1[1] + 1, pos1[2] - 1 })
  local wincol2 = M.get_wincol(0, { pos2[1] + 1, pos2[2] - 1 })
  -- P { "start_wincol1=", wincol1, "start_wincol2=", wincol2, pos1, pos2 }

  local row_flip = pos1[1] > pos2[1]
  local col_flip = wincol1 > wincol2

  -- the starting points
  --[[  ┌───────┐
        │s      │  s: resolve to left     row_flip: false
        │      e│  e: resolve to right    col_flip: false
        └───────┘
        ┌───────┐
        │      e│  s: resolve to left     row_flip: true 
        │s      │  e: resolve to right    col_flip: false 
        └───────┘
        ┌───────┐
        │      s│  s: resolve to right    row_flip: true 
        │e      │  e: resolve to left     col_flip: true 
        └───────┘
        ┌───────┐
        │e      │  s: resolve to right    row_flip: false 
        │      s│  e: resolve to left     col_flip: true 
        └───────┘
  --]]

  -- need to evaluate from original rows
  P { "start_wincol1=", wincol1, "start_wincol2=", wincol2, "col_flip=", col_flip, pos1, pos2 }
  local _, wincol1 = M.convert_wincol_to_byteindex(0, pos1[1], wincol1, col_flip)
  local _, wincol2 = M.convert_wincol_to_byteindex(0, pos2[1], wincol2, col_flip)
  local min_wincol = M.get_min_wincol(0)
  P { "Resolved wincol1=", wincol1, "wincol2=", wincol2 }

  if row_flip then
    pos1[1], pos2[1] = pos2[1], pos1[1]
  end
  if col_flip then
    wincol1, wincol2 = wincol2, wincol1
  end

  local start_wincol = wincol1
  local end_wincol = wincol2
  -- if  and pos1[1] == pos2[1] then
  --   wincol1, wincol2 = wincol2, wincol1
  -- end

  local start_row = pos1[1]
  local end_row = pos2[1]

  -- if mode == "V" then
  --   local lines = api.nvim_buf_get_lines(0, start_row, end_row + 1, true)
  --   -- P(table.concat(lines, " "))
  -- end

  local out = {}
  local lines = api.nvim_buf_get_lines(0, start_row, end_row + 1, true)
  local i = 1
  local start_index, end_index
  P {
    "start_row=",
    start_row,
    "end_row=",
    end_row,
    "start_wincol=",
    start_wincol,
    "end_wincol=",
    end_wincol,
    "min_wincol=",
    min_wincol,
  }
  for r = start_row, end_row do
    local begin_wincol = (i == 1 or mode == "") and start_wincol or min_wincol
    local ending_wincol = (r == end_row or mode == "") and end_wincol or M.get_max_wincol(0, r + 1)
    -- start_index = M.wincol_byteindex(0, r - 1, begin_wincol, false, true)
    -- end_index = M.wincol_byteindex(0, r - 1, ending_wincol, false, false)
    start_index = M.convert_wincol_to_byteindex(0, r, begin_wincol, false)
    end_index = M.convert_wincol_to_byteindex(0, r, ending_wincol, true)
    P { r, start_wincol, ending_wincol, begin_wincol, ending_wincol, start_index, end_index }
    P { "start_index=", start_index, "end_index=", end_index }
    table.insert(out, lines[i]:sub(start_index, end_index))
    i = i + 1
  end
  P(table.concat(out, " "))
  P { "i=", i }
end

vnoremap { "<C-x>", visual_selection }
vnoremap {
  "<C-s>",
  function()
    P(M.get_max_wincol(0, vim.api.nvim_win_get_cursor(0)[1]))
  end,
}
return M
