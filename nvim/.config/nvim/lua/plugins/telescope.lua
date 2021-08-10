-- this file may contain configuration related to ongoing telescope work
-- it's not a COPYME

local status, telescope = pcall(require, "telescope")
if not status then
  return
end

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_utils = require "telescope.actions.utils"
local action_mt = require "telescope.actions.mt"

ta = require "telescope.actions"
ts = require "telescope.actions.state"
tu = require "telescope.actions.utils"

--- PR #1093
-- local print_entry
-- print_entry = actions.register_actions({
--   print_entry = function()
--     print(vim.inspect(action_state.get_selected_entry()))
--   end,
--   print_ordinal = function()
--     P(vim.inspect(action_state.get_selected_entry()))
--   end,
-- })[1]

telescope.setup {
  defaults = {
    mappings = {
      i = {
        -- PR #1093
        -- ["<C-x>"] = actions.print_entry + actions.toggle_selection,
        ["<C-space><CR>"] = function(prompt_bufnr)
          require("telescope").extensions.hop._hop(prompt_bufnr, { callback = actions.select_default })
        end,
        ["<C-space>v"] = function(prompt_bufnr)
          require("telescope").extensions.hop._hop(prompt_bufnr, { callback = actions.select_vertical })
        end,
        ["<C-space>h"] = function(prompt_bufnr)
          require("telescope").extensions.hop._hop(prompt_bufnr, { callback = actions.select_horizontal })
        end,
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
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
    },
  },
  pickers = {
    find_files = {
      on_input_filter_cb = function(prompt)
        if prompt:sub(#prompt) == "@" then
          vim.schedule(function()
            local prompt_bufnr = vim.api.nvim_get_current_buf()
            require("telescope.actions").select_default(prompt_bufnr)
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
          ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
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
telescope.load_extension "hop"
telescope.load_extension "fzf"

local opts = { silent = true }
local ts_builtin = require "telescope.builtin"

nnoremap { "<space><space>f", ts_builtin.find_files, opts }
nnoremap { "<space><space>rs", ts_builtin.grep_string, opts }
vnoremap {
  "<space><space>rg",
  function()
    ts_builtin.grep_string { default_text = require("utils").visual_selection() }
  end,
  opts,
}
nnoremap { "<space><space>b", ts_builtin.buffers, opts }
nnoremap { "<space><space>rg", ts_builtin.live_grep, opts }
nnoremap { "<space><space>man", ts_builtin.man_pages, opts }
nnoremap { "<space><space>help", ts_builtin.help_tags, opts }
nnoremap { "<space><space>bi", ts_builtin.builtin, opts }
nnoremap { "<space><space>rb", ts_builtin.current_buffer_fuzzy_find, opts }
nnoremap { "<space><space>gb", ts_builtin.git_branches, opts }
nnoremap { "<space><space>gc", ts_builtin.git_commits, opts }
nnoremap { "<space><space>gs", ts_builtin.git_status, opts }
nnoremap { "<space><space>sg", ts_builtin.git_stash, opts }
nnoremap { "<space><space>bf", ts_builtin.file_browser, opts }
nnoremap { "<space><space>jl", ts_builtin.jumplist, opts }
nnoremap { "gD", vim.lsp.buf.declaration, opts }
nnoremap { "gi", vim.lsp.buf.implementation, opts }
nnoremap { "gd", ts_builtin.lsp_definitions, opts }
nnoremap { "gr", ts_builtin.lsp_references, opts }
nnoremap { "<space>ds", ts_builtin.lsp_document_symbols, opts }
nnoremap {
  "<space>fs",
  partial(ts_builtin.lsp_document_symbols, { symbols = { "function", "method" } }),
  opts,
}
nnoremap { "<space>cs", partial(ts_builtin.lsp_document_symbols, { symbols = "class" }), opts }
nnoremap { "<space>db", ts_builtin.lsp_document_diagnostics, opts }
nnoremap { "<space>dw", ts_builtin.lsp_workspace_diagnostics, opts }
nnoremap {
  "<space>ws",
  function()
    ts_builtin.lsp_workspace_symbols { query = vim.fn.input "> " }
  end,
  opts,
}
nnoremap { "<space>wsd", ts_builtin.lsp_dynamic_workspace_symbols, opts }
