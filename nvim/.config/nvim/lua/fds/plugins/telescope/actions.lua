local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_mt = require "telescope.actions.mt"
local Path = require "plenary.path"
local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

local get_relative_path = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local current_buf = vim.api.nvim_win_get_buf(current_picker.original_win_id)
  -- buffer name is typically filepath
  local current_buf_path = Path:new(vim.api.nvim_buf_get_name(current_buf))
  local entry_path = Path:new(action_state.get_selected_entry().path)
  return entry_path:make_relative(current_buf_path:parent():absolute())
end

-- insert mode in picker
M.insert_relative_path = function(prompt_bufnr)
  local symbol = get_relative_path(prompt_bufnr)
  local mode = vim.api.nvim_get_mode().mode
  -- adapted actions.insert_symbol_i and actions.insert_symbol
  -- from $PLUGIN_FOLDER/lua/telescope/actions/init.lua
  if mode == "i" then
    actions._close(prompt_bufnr, true)
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_buf_set_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2], { symbol })
    vim.schedule(function()
      vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] + #symbol })
    end)
  else
    actions.close(prompt_bufnr)
    vim.api.nvim_put({ symbol }, "", true, true)
  end
end

-- recursively asscend up until passed node
local get_node_recursively = function(opts)
  opts = opts or {}
  opts.win_id = vim.F.if_nil(opts.win_id, 0)
  opts.type = vim.F.if_nil(opts.type, "carryover_tag_set")
  local current_node = ts_utils.get_node_at_cursor(opts.win_id)
  if not current_node then
    return ""
  end
  local expr = current_node

  while expr:type() ~= opts.type do
    expr = expr:parent()
  end
  local ret = ts_utils.node_to_lsp_range(expr)
  return ret
end

local find_buffer_by_name = function(filename)
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:find(filename) then
      return buf
    end
  end
end

local load_file = function(filename)
  vim.cmd(string.format("bad %s", filename))
  local buf_nr = find_buffer_by_name(filename)
  vim.fn.bufload(buf_nr)
  return buf_nr
end

local append_lines_to_buf = function(lines, bufnr, opts)
  opts = opts or {}
  opts.with_space = vim.F.if_nil(opts.with_space, true)
  if opts.with_space then
    table.insert(lines, 1, "")
  end
  local buf_line_count = vim.api.nvim_buf_line_count(bufnr)
  vim.api.nvim_buf_set_lines(bufnr, buf_line_count, buf_line_count + #lines, false, lines)
  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd [[write! ]]
  end)
end

M.append_task = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local original_win_id = current_picker.original_win_id
  local original_buf_nr = vim.api.nvim_win_get_buf(original_win_id)

  local node_range = get_node_recursively { win_id = original_win_id, type = "carryover_tag_set" }

  local task_lines = vim.api.nvim_buf_get_lines(
    original_buf_nr,
    node_range["start"].line,
    node_range["end"].line + 1,
    false
  )

  local filename = action_state.get_selected_entry().path
  local buf_nr = load_file(filename)
  append_lines_to_buf(task_lines, buf_nr)

  vim.api.nvim_buf_call(original_buf_nr, function()
    vim.cmd(string.format("%s,%sdelete", node_range["start"].line + 1, node_range["end"].line + 1))
  end)
end

return action_mt.transform_mod(M)
