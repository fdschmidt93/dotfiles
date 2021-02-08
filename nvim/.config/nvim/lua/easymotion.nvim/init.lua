api = vim.api

-- Concept
-- 1. Get visible lines
-- 2. Get positions of search string
-- 3. Matcher
--      Substring
--      Word
--      Incremental
-- 4. Rank positions by closeness to current cursor
-- 5. Assign keys from homerow for jump
-- Other
--      Repeat motion
G = {}
--
-- function get_visible_region()
--     -- lines: 1-indexed
--     -- -- local first_end_col = vim.fn.col{first_line, '0'}
--     -- local last_end_col = vim.fn.col{last_line, '$'} - 1
--     -- region = vim.region(0, {first_line, 0}, {last_line, last_end_col}, "", true)
--     -- return region
--     return first_line, last_line
-- end

function get_visible_lines()
    local first_line = vim.fn.line('w0')
    local last_line = vim.fn.line('w$')
    return api.nvim_buf_get_lines(0, first_line-1, last_line, true)
end

M = {}

-- local M.get_matches(input, lines)
--     -- for each line
--     -- get matches -> map coordinates of matches
--     return
-- end

local function M.find_all(str, substr)
    local first = 0
    local offsets = {}
    while true do
        local offset = {str:find(substr, first+1)}
        if not vim.tbl_isempty(offset) then
            first = offset[1]  -- set first anew
            table.insert(offsets, offset)
        else
            break
        end
    end
    if vim.tbl_isempty(offsets) then
        return nil
    else
        return offsets
    end
end


-- Match attributes
-- Coordinates -> euclidean distance to cursor pos

function M.euclidean_dist(r1, c1, r2, c2)
    local row_dist = M.square(r1 - r2)
    local col_dist = M.square(c1 - c2)
    return math.sqrt(row_dist + col_dist)
end

function M._square(x)
    return x * x
end
