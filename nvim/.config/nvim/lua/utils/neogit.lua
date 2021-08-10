-- WIP on telescope integration for neogit
local status, telescope = pcall(require, "telescope")
if not status then
  return
end
local cli = require "neogit.lib.git.cli"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local a = require "plenary.async_lib"
local async, await, scheduler = a.async, a.await, a.scheduler

local M = {}

ng = function()
  R("telescope.builtin").git_branches {
    attach_mappings = function(_, map)
      map(
        "i",
        "<CR>",
        function()
          local branch = action_state.get_selected_entry().name
          P(branch)
          cli.checkout.branch(branch).call()
        end
      )
      return true
    end,
  }
end

return M
