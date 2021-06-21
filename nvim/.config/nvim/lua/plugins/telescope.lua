local status, telescope = pcall(require, "telescope")
if not status then
  return
end

local action_state = require "telescope.actions.state"
require("telescope").setup {
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
  },
  pickers = {
    git_commits = {
      mappings = {
        i = {
          ["<C-o>"] = function(prompt_bufnr)
            R("telescope.actions").close(prompt_bufnr)
            local value = R("telescope.actions").get_selected_entry(prompt_bufnr).value
            vim.cmd("DiffviewOpen " .. value .. "~1.." .. value)
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
                  local new_buf = vim.F.if_nil(
                    table.remove(replacement_buffers),
                    vim.api.nvim_create_buf(false, true)
                  )
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

telescope.load_extension "fzf"
-- telescope.load_extension('project')

-- local dropdown_opts = R('telescope.themes').get_dropdown {
--   border = true,
--   previewer = false,
--   shorten_path = false,
--   prompt_prefix = "> ",
--   results_height = 30
-- }

-- -- local find_nvim = function()
-- --   -- agnostic to local or ssh
-- --   local user = os.getenv('USER')
-- --   local opts = vim.deepcopy(dropdown_opts)
-- --   opts.prompt = 'Neovim'
-- --   opts.cwd = string.format('/home/%s/.config/nvim/', user)
-- --   R('telescope.builtin').find_files(opts)
-- -- end

-- -- local find_notes = function()
-- --   local user = os.getenv('USER')
-- --   R('telescope.builtin').find_files {
-- --     prompt = 'Neovim',
-- --     cwd = string.format('/home/%s/notes/', user)
-- --   }
-- -- end

-- -- local find_meetings = function()
-- --   local user = os.getenv('USER')
-- --   R('telescope.builtin').find_files {
-- --     prompt = 'Neovim',
-- --     cwd = string.format('/home/%s/phd/meetings', user)
-- --   }
-- -- end

-- -- mappings

local opt = { silent = true }
local ts_builtin = R "telescope.builtin"
nnoremap { "<space><space>f", ts_builtin.find_files, opt }
nnoremap { "<space><space>rs", ts_builtin.grep_string, opt }
vnoremap {
  "<space><space>rg",
  function()
    ts_builtin.grep_string { query = require("utils").visual_selection() }
  end,
  opt,
}
nnoremap { "<space><space>rg", ts_builtin.live_grep, opt }
nnoremap { "<space><space>man", ts_builtin.man_pages, opt }
nnoremap { "<space><space>help", ts_builtin.help_tags, opt }
nnoremap { "<space><space>bi", ts_builtin.builtin, opt }
nnoremap { "<space><space>rb", ts_builtin.current_buffer_fuzzy_find, opt }
nnoremap { "<space><space>gb", ts_builtin.git_branches, opt }
nnoremap { "<space><space>gc", ts_builtin.git_commits, opt }
nnoremap { "<space><space>gs", ts_builtin.git_stash, opt }
nnoremap { "<space><space>bf", ts_builtin.file_browser, opt }

-- -- nnoremap {'<space><space>nvim', find_nvim, opt}
-- -- nnoremap {'<leader><leader>n', find_notes, opt}
