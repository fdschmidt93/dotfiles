local M = {}

-- prefer earlier lines for entries with same score
M.line_tiebreak = function(current_entry, existing_entry)
  -- returning true means preferring current entry
  return current_entry.lnum < existing_entry.lnum
end

return M
