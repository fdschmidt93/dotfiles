-- this file may contain configuration related to ongoing telescope work
-- it's not a COPYME
local status, telescope = pcall(require, "telescope")
if not status then
  return
end

local action_state = require "telescope.actions.state"
local action_utils = require "telescope.actions.utils"
local actions = require "telescope.actions"
local fds_tele_actions = require "fds.plugins.telescope.actions"
local fds_tele_utils = require "fds.plugins.telescope.utils"
local ts_state = require "telescope.state"
local ts_utils = require "telescope.utils"

-- global short hands for telescope.nvim development
TA, TS, TU, ST, UT = actions, action_state, action_utils, ts_state, ts_utils
FBA = require("telescope").extensions.file_browser.actions
-- find and get prompt buffer
TP = function()
  local prompt_buf = vim.tbl_filter(function(b)
    return vim.bo[b].filetype == "TelescopePrompt"
  end, vim.api.nvim_list_bufs())[1]
  return TelescopeGlobalState[prompt_buf].picker
end

telescope.setup {
  defaults = {
    borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
    layout_strategy = "vertical",
    layout_config = {
      height = 0.90,
      prompt_position = "top",
      preview_height = 15,
    },
    prompt_prefix = " ",
    sorting_strategy = "ascending",
    cache_picker = {
      num_pickers = 20,
    },
    history = {
      path = vim.env.HOME .. "/.local/share/nvim/telescope_history.sqlite3",
      limit = 100,
    },
    dynamic_preview_title = true,
    mappings = {
      i = {
        ["<A-p>"] = require("telescope.actions.layout").toggle_preview,
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<F1>"] = actions.which_key,
      },
      n = {
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<F1>"] = actions.which_key,
      },
    },
  },
  extensions = {
    file_browser = {
      grouped = true,
      previewer = false,
      hijack_netrw = true,
      mappings = {
        ["n"] = {
          ["o"] = require "telescope.actions".select_default,
        }
      }
    },
    fzf = {
      fuzzy = false, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
  },
  pickers = {
    grep_string = {
      -- only sort top 50 entries
      temp__scrolling_limit = 50,
    },
    live_grep = {
      on_input_filter_cb = function(prompt)
        -- AND operator for live_grep like how fzf handles spaces
        return { prompt = prompt:gsub("%s", ".*") }
      end,
      mappings = {
        i = {
          -- toggle input filter cb
          ["<C-a>"] = function(prompt_bufnr)
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            if current_picker._on_input_filter_cb_cached then
              current_picker._on_input_filter_cb = current_picker._on_input_filter_cb_cached
              current_picker._on_input_filter_cb_cached = nil
            else
              current_picker._on_input_filter_cb_cached = current_picker._on_input_filter_cb
              current_picker._on_input_filter_cb = function() end
            end
            current_picker:refresh()
          end,
        },
      },
    },
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
      mappings = {
        i = {
          ["<C-a>"] = require("fds.plugins.telescope.actions").append_task,
          ["<C-s>"] = require("fds.plugins.telescope.actions").insert_relative_path,
        },
      },
      -- trigger current_buffer_fuzzy_find in currently selected file with appending "@"
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
          ["<C-l>r"] = fds_tele_actions.diffview_relative,
          ["<C-l>a"] = fds_tele_actions.diffview_absolute,
          ["<C-l>u"] = fds_tele_actions.diffview_upstream_master,
          ["<C-r>r"] = fds_tele_actions.revert_commit,
        },
      },
    },
    buffers = {
      initial_mode = "normal",
      sort_mru = true,
      sort_lastused = true,
      mappings = {
        n = {
          ["x"] = function(prompt_bufnr)
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
    current_buffer_fuzzy_find = {
      tiebreak = fds_tele_utils.line_tiebreak,
    },
    git_status = {
      mappings = {
        i = {
          ["<C-r>"] = fds_tele_actions.reset_to_head,
        },
      },
    },
    git_stash = {
      mappings = {
        i = {
          ["<C-d>"] = fds_tele_actions.delete_stash,
        },
      },
    },
    quickfixhistory = {
      mappings = {
        i = {
          ["<C-s>"] = fds_tele_actions.open_entry_in_qf,
        },
      },
    },
  },
}

telescope.load_extension "fzf"
telescope.load_extension "file_browser"

if require("ffi").load "libsqlite3" then
  telescope.load_extension "smart_history"
end
