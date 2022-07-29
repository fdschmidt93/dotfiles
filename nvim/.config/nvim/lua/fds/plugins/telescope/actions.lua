local action_mt = require "telescope.actions.mt"
local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local fds_ts_utils = require "fds.plugins.telescope.utils"
local ts_utils = require "telescope.utils"

local M = {}

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

M.open_entry_in_qf = function(prompt_buf)
  local entry = action_state.get_selected_entry()
  actions.close(prompt_buf)
  vim.cmd(string.format("%schistory | copen", entry.nr))
end

return action_mt.transform_mod(M)
