local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"

local M = {}

M.neorg_files = function(opts)
  opts = opts or {}
  require("telescope.builtin").find_files {
    search_dirs = { "~/neorg/" },
  }
end

M.neorg_grep = function(opts)
  opts = opts or {}
  require("telescope.builtin").live_grep {
    cwd = "~/neorg/",
  }
end

M.papers = function(opts)
  opts = opts or {}
  local cwd = "~/phd/papers"
  require("telescope.builtin").find_files {
    previewer = false,
    cwd = cwd,
    attach_mappings = function(_, map)
      action_set.select:replace(function()
        local entry = action_state.get_selected_entry()
        local stderr = {}
        require("plenary.job")
          :new({
            command = "zathura",
            args = { entry.value },
            cwd = cwd,
            on_stderr = function(_, data)
              table.insert(stderr, data)
            end,
          })
          :start()
      end)
      map("i", "<CR>", function(prompt_bufnr)
        actions.select_default(prompt_bufnr)
        actions.close(prompt_bufnr)
      end)
      map("i", "<C-v>", function(prompt_bufnr)
        actions.select_default(prompt_bufnr)
      end)
      map("i", "<C-x>", function(prompt_bufnr)
        actions.select_default(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.cmd [[wqa!]]
      end)
      return true
    end,
  }
end

return M
