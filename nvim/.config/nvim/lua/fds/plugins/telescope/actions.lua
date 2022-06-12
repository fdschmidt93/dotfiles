local action_mt = require "telescope.actions.mt"
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local fds_ts_utils = require "fds.plugins.telescope.utils"
local ts_utils = require "telescope.utils"

local M = {}

-- insert mode in picker
M.insert_relative_path = function(prompt_bufnr)
  local symbol = fds_ts_utils.get_relative_path(prompt_bufnr)
  local mode = vim.api.nvim_get_mode().mode
  -- adapted actions.insert_symbol_i and actions.insert_symbol
  -- from $PLUGIN_FOLDER/lua/telescope/actions/init.lua
  if mode == "i" then
    actions.close(prompt_bufnr)
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

-- neorg
M.append_task = function(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local original_win_id = current_picker.original_win_id
  local original_buf_nr = vim.api.nvim_win_get_buf(original_win_id)

  local node_range = fds_ts_utils.get_node_recursively { win_id = original_win_id, type = "carryover_tag_set" }

  local task_lines = vim.api.nvim_buf_get_lines(
    original_buf_nr,
    node_range["start"].line,
    node_range["end"].line + 1,
    false
  )
  local filename = vim.loop.cwd() .. "/" .. action_state.get_selected_entry().value:sub(3, -1)
  local buf_nr = fds_ts_utils.load_file(filename)
  fds_ts_utils.append_lines_to_buf(task_lines, buf_nr)

  vim.api.nvim_buf_call(original_buf_nr, function()
    vim.cmd(string.format("%s,%sdelete", node_range["start"].line + 1, node_range["end"].line + 1))
  end)
end

M.diffview_relative = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local value = action_state.get_selected_entry().value
  vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
end

M.diffview_absolute = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local value = action_state.get_selected_entry().value
  vim.cmd("DiffviewOpen " .. value)
end

M.diffview_upstream_master = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local value = action_state.get_selected_entry().value
  local rev = ts_utils.get_os_command_output({ "git", "rev-parse", "upstream/master" }, vim.loop.cwd())[1]
  vim.cmd("DiffviewOpen " .. rev .. " " .. value)
end

M.revert_commit = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  local _, ret, stderr = ts_utils.get_os_command_output {
    "git",
    "revert",
    selection.value,
  }
  if ret == -1 then
    vim.notify("Reset to HEAD: " .. selection.value, vim.log.levels.INFO)
  else
    vim.notify(
      string.format('Error when applying: %s. Git returned: "%s"', selection.value, table.concat(stderr, "  ")),
      vim.log.levels.ERROR
    )
  end
end

M.reset_file_to_head = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  local _, ret, stderr = ts_utils.get_os_command_output {
    "git",
    "checkout",
    "HEAD",
    "--",
    selection.value,
  }
  if ret == -1 then
    vim.notify("Reset to HEAD: " .. selection.value, vim.log.levels.INFO)
  else
    vim.notify(
      string.format('Error when applying: %s. Git returned: "%s"', selection.value, table.concat(stderr, "  ")),
      vim.log.levels.ERROR
    )
  end
end

M.delete_stash = function(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  actions.close(prompt_bufnr)
  local _, ret, stderr = ts_utils.get_os_command_output {
    "git",
    "stash",
    "drop",
    selection.value,
  }
  if ret == 0 then
    vim.notify("dropped: " .. selection.value, vim.log.levels.INFO)
  else
    vim.notify(
      string.format('Error when applying: %s. Git returned: "%s"', selection.value, table.concat(stderr, "  ")),
      vim.log.levels.WARN
    )
  end
end

return action_mt.transform_mod(M)
