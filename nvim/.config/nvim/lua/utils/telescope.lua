local status, telescope = pcall(require, 'telescope')
if not status then return end

local M = {}
local api = vim.api

local action_state = require('telescope.actions.state')

function M.toggle_all()
  local prompt_bufnr = vim.api.nvim_get_current_buf()
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  -- indices are 1-indexed, rows are 0-indexed
  local i = 1
  for entry in current_picker.manager:iter() do
    current_picker._multi:toggle(entry)
    -- highlighting
    local row = current_picker:get_row(i)
    -- TODO fix row > 0 in can_select_row(row)
    if current_picker:can_select_row(row) and row > 0 then
      -- if true then
      current_picker.highlighter:hi_multiselect(row, current_picker._multi:is_selected(entry))
    end
    i = i + 1
  end
  -- current_picker:refresh()
end
