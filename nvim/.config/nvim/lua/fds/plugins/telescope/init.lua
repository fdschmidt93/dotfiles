-- this file may contain configuration related to ongoing telescope work
-- it's not a COPYME
local status, telescope = pcall(require, "telescope")
if not status then
  return
end

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_utils = require "telescope.actions.utils"
local Path = require "plenary.path"

-- local action_generate = require "telescope.actions.generate"
local ts_utils = require "telescope.utils"
local ts_state = require "telescope.state"

-- global short hands for telescope.nvim development
ta = actions
ts = action_state
st = ts_state
tu = action_utils
ut = ts_utils
tp = function()
  return TelescopeGlobalState[B()].picker
end

telescope.setup {
  defaults = {
    cache_picker = {
      num_pickers = 20,
    },
    preview = {
      filesize_limit = 5,
      timeout = 150,
      treesitter = true,
      filesize_hook = function(filepath, bufnr, opts)
        local path = Path:new(filepath)
        local height = vim.api.nvim_win_get_height(opts.winid)
        local lines = vim.split(path:head(height), "[\r]?\n")
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      end,
    },
    history = {
      path = vim.env.HOME .. "/.local/share/nvim/databases/telescope_history.sqlite3",
      limit = 100,
    },
    dynamic_preview_title = true,
    mappings = {
      i = {
        ["<PageUp>"] = actions.move_selection_next,
        ["<PageDown>"] = actions.move_selection_previous,
        ["<C-space><CR>"] = function(prompt_bufnr)
          require("telescope").extensions.hop._hop(prompt_bufnr, { callback = actions.select_default })
        end,
        ["<C-space>v"] = function(prompt_bufnr)
          require("telescope").extensions.hop._hop(prompt_bufnr, { callback = actions.select_vertical })
        end,
        ["<C-space>h"] = function(prompt_bufnr)
          require("telescope").extensions.hop._hop(prompt_bufnr, { callback = actions.select_horizontal })
        end,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
      },
      n = {
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
      },
    },
  },
  extensions = {
    hop = {
      sign_hl = { "WarningMsg", "Title" },
      line_hl = { "CursorLine", "Normal" },
      trace_entry = true,
      clear_selection_hl = false,
    },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
  },
  pickers = {
    find_files = {
      mappings = {
        i = {
          ["<C-a>"] = function(prompt_bufnr)
            R("fds.telescope.actions").append_task(prompt_bufnr)
          end,
        },
      },
      on_input_filter_cb = function(prompt)
        if prompt:sub(#prompt) == "@" then
          vim.schedule(function()
            local prompt_bufnr = vim.api.nvim_get_current_buf()
            actions.select_default(prompt_bufnr)
            require("telescope.builtin").current_buffer_fuzzy_find()
            -- properly enter prompt in insert mode
            vim.cmd [[normal! A]]
          end)
        end
      end,
    },
    git_commits = {
      mappings = {
        i = {
          ["<C-l>"] = function(prompt_bufnr)
            R("telescope.actions").close(prompt_bufnr)
            local value = action_state.get_selected_entry().value
            vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
          end,
          ["<C-a>"] = function(prompt_bufnr)
            R("telescope.actions").close(prompt_bufnr)
            local value = action_state.get_selected_entry().value
            vim.cmd("DiffviewOpen " .. value)
          end,
          ["<C-u>"] = function(prompt_bufnr)
            R("telescope.actions").close(prompt_bufnr)
            local value = action_state.get_selected_entry().value
            local rev = ts_utils.get_os_command_output({ "git", "rev-parse", "upstream/master" }, vim.loop.cwd())[1]
            vim.cmd("DiffviewOpen " .. rev .. " " .. value)
          end,
        },
      },
    },
    buffers = {
      mappings = {
        i = {
          ["<C-x>"] = function(prompt_bufnr)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local selected_bufnr = action_state.get_selected_entry().bufnr

            --- get buffers with lower number
            local replacement_buffers = {}
            for entry in current_picker.manager:iter() do
              if entry.bufnr < selected_bufnr then
                table.insert(replacement_buffers, 1, entry.bufnr)
              end
            end

            current_picker:delete_selection(function(selection)
              local bufnr = selection.bufnr
              -- get associated window(s)
              local winids = vim.fn.win_findbuf(bufnr)
              -- get windows in current tab to check
              local tabwins = vim.api.nvim_tabpage_list_wins(0)
              -- fill winids with new empty buffers
              for _, winid in ipairs(winids) do
                if vim.tbl_contains(tabwins, winid) then
                  local new_buf = vim.F.if_nil(table.remove(replacement_buffers), vim.api.nvim_create_buf(false, true))
                  vim.api.nvim_win_set_buf(winid, new_buf)
                end
              end
              -- remove buffer at last
              vim.api.nvim_buf_delete(bufnr, { force = true })
            end)
          end,
        },
      },
    },
    git_status = {
      mappings = {
        i = {
          ["<C-r>"] = function(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            local _, ret, stderr = R("telescope.utils").get_os_command_output {
              "git",
              "checkout",
              "HEAD",
              "--",
              selection.value,
            }
            if ret == 0 then
              print("Reset to HEAD: " .. selection.value)
            else
              print(
                string.format(
                  'Error when applying: %s. Git returned: "%s"',
                  selection.value,
                  table.concat(stderr, "  ")
                )
              )
            end
          end,
        },
      },
    },
    git_stash = {
      mappings = {
        i = {
          ["<C-d>"] = function(prompt_bufnr)
            local selection = R("telescope.actions").get_selected_entry()
            R("telescope.actions").close(prompt_bufnr)
            local _, ret, stderr = R("telescope.utils").get_os_command_output {
              "git",
              "stash",
              "drop",
              selection.value,
            }
            if ret == 0 then
              print("dropped: " .. selection.value)
            else
              print(
                string.format(
                  'Error when applying: %s. Git returned: "%s"',
                  selection.value,
                  table.concat(stderr, "  ")
                )
              )
            end
          end,
        },
      },
    },
  },
}
telescope.load_extension "file_browser"
telescope.load_extension "frecency"
telescope.load_extension "fzf"
telescope.load_extension "hop"
telescope.load_extension "project"
telescope.load_extension "smart_history"
telescope.load_extension "ui-select"
