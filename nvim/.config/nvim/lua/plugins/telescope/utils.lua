local status, _ = pcall(require, "telescope")
if not status then
  return
end

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local M = {}

--- Replace multi-selected buffers with previous buffers in the list, respectively.
--- Falls back to empty unlisted scratch buffer as placeholder if no valid buffers found.
--- See also: https://github.com/moll/vim-bbye
---@param prompt_bufnr number: The prompt bufnr
M.bbye_buffer = function(prompt_bufnr)
  if prompt_bufnr == nil then
    if vim.bo.filetype == "TelescopePrompt" then
      prompt_bufnr = vim.api.nvim_get_current_buf()
    else
      print "Not in Telescope prompt"
      return
    end
  end
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local selected_buf = actions.map_selections(prompt_bufnr, function(selection)
    return selection.bufnr
  end)

  local replacement_buffers = {}
  for entry in current_picker.manager:iter() do
    if not vim.tbl_contains(selected_buf, entry.bufnr) then
      table.insert(replacement_buffers, entry.bufnr)
    end
  end
  table.sort(replacement_buffers, function(x, y)
    return x < y
  end)

  current_picker:delete_selection(function(selection)
    local bufnr = selection.bufnr
    -- get associated window(s)
    local winids = vim.fn.win_findbuf(bufnr)

    local selection_replacements = {}
    for _, buf in ipairs(replacement_buffers) do
      if buf < bufnr then
        table.insert(selection_replacements, buf)
      end
    end

    for _, winid in ipairs(winids) do
      local new_buf = vim.F.if_nil(table.remove(selection_replacements), vim.api.nvim_create_buf(false, true))
      vim.api.nvim_win_set_buf(winid, new_buf)
    end
    -- remove buffer at last
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end)
end

return M
