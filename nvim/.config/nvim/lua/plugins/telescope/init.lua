-- this file may contain configuration related to ongoing telescope work
-- it's not a COPYME
return {
  "nvim-telescope/telescope.nvim",
  dev = true,
  keys = "<space><space>",
  event = "VeryLazy",
  cmd = "Telescope",
  lazy = true,
  dependencies = {
    "plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    },
    { "nvim-telescope/telescope-symbols.nvim" },
    {
      "nvim-telescope/telescope-smart-history.nvim",
      dependencies = "kkharji/sqlite.lua",
    },
    { "nvim-telescope/telescope-file-browser.nvim", branch = "feat/tree", dev = true },
    { "fdschmidt93/telescope-egrepify.nvim", dev = true },
    { "fdschmidt93/telescope-corrode.nvim", dev = true },
  },
  config = function()
    local status, telescope = pcall(require, "telescope")
    if not status then
      return
    end

    local action_state = require "telescope.actions.state"
    local action_utils = require "telescope.actions.utils"
    local actions = require "telescope.actions"
    local fds_tele_actions = require "plugins.telescope.actions"
    local fds_tele_utils = require "plugins.telescope.utils"
    local ts_state = require "telescope.state"
    local ts_utils = require "telescope.utils"

    -- global short hands for telescope.nvim development
    TA, TS, TU, ST, UT = actions, action_state, action_utils, ts_state, ts_utils
    FBA = require("telescope").extensions.file_browser.actions
    -- find and get prompt buffer
    TP = function()
      local prompt_buf =
        vim.tbl_filter(function(b) return vim.bo[b].filetype == "TelescopePrompt" end, vim.api.nvim_list_bufs())[1]
      return TelescopeGlobalState[prompt_buf].picker
    end

    telescope.setup {
      defaults = {
        layout_strategy = "vertical",
        layout_config = {
          height = function(_, _, l) return l end,
          width = function(_, c, _) return c end,
          prompt_position = "top",
          preview_height = 0.40,
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
        egrepify = {
          results_ts_hl = true,
          AND = true,
          lnum = true, -- default, not required
          lnum_hl = "EgrepifyLnum", -- default, not required
          -- col = true, -- default, not required
          col_hl = "EgrepifyCol", -- default, not required
          filename_hl = "@title.emphasis",
          title_suffix_hl = "Comment",
        },
        file_browser = {
          grouped = true,
          previewer = false,
          initial_browser = "tree",
          -- searching activates a `telescope.find_files` like finder
          -- you can use this to enter directories and remove ( move, copy) files to
          -- selected dir (or selected dir of file) etc.
          auto_depth = true,
          depth = 1,
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
        treesitter = {
          mappings = {
            ["i"] = {
              ["<C-s>"] = require("plugins.telescope.treesitter").send_to_repl,
            },
          },
        },
        buffers = {
          sort_mru = true,
          sort_lastused = true,
          mappings = {
            n = {
              ["x"] = actions.delete_buffer,
            },
            i = {
              ["<CR>"] = function(prompt_bufnr)
                local current_picker = action_state.get_current_picker(prompt_bufnr)
                current_picker.get_selection_window = function(_, entry)
                  local wins = vim
                    .iter(vim.api.nvim_tabpage_list_wins(0))
                    :filter(function(w) return vim.api.nvim_win_get_buf(w) == entry.bufnr end)
                    :totable()
                  vim.print(#wins)
                  return #wins == 1 and wins[1] or 0
                end
                actions.select_default(prompt_bufnr)
              end,
              ["<C-x>"] = actions.delete_buffer,
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
    telescope.load_extension "egrepify"
    telescope.load_extension "corrode"

    if require("ffi").load "libsqlite3" then
      telescope.load_extension "smart_history"
    end

    local ts = setmetatable({}, {
      __index = function(_, key)
        return function(topts)
          local mode = vim.api.nvim_get_mode().mode
          topts = topts or {}
          if mode == "v" or mode == "V" or mode == "" then
            topts.default_text = table.concat(require("fds.utils").get_selection())
          end
          if key == "grep" then
            require("telescope").extensions.egrepify.egrepify(topts)
          elseif key == "find_files" then
            require("telescope").extensions.corrode.corrode(topts)
          elseif key == "file_browser" then
            require("telescope").extensions.file_browser.file_browser(topts)
          else
            local builtin = require "telescope.builtin"
            builtin[key](topts)
          end
        end
      end,
    })
    local ts_leader = "<space><space>"
    local set = vim.keymap.set
    set("n", ts_leader .. "ff", ts.find_files, { silent = true, desc = "Telescope: Find Files" })
    set(
      "n",
      ts_leader .. "F",
      function() ts.find_files { cwd = "%:p:h" } end,
      { silent = true, desc = "Telescope: Find Files in CWD" }
    )
    set("n", "<M-x>", ts.commands, { silent = true, desc = "Telescope: Commands" })
    set("i", "<C-f>", ts.find_files, { silent = true, desc = "Telescope: Find Files" })
    set("i", "<C-s>", ts.symbols, { silent = true, desc = "Telescope: Symbols" })
    set({ "n", "v" }, ts_leader .. "rs", ts.grep_string, { silent = true, desc = "Telescope: Grep String" })
    set("n", ts_leader .. "bb", ts.buffers, { silent = true, desc = "Telescope: Buffers" })

    set("n", ts_leader .. "bf", ts.file_browser, { silent = true, desc = "Telescope: File Browser" })
    set(
      "n",
      ts_leader .. "bF",
      function() ts.file_browser { path = "%:p:h", select_buffer = true } end,
      { silent = true, desc = "Telescope: File Browser (current buffer)" }
    )
    set("n", ts_leader .. "bi", ts.builtin, { silent = true, desc = "Telescope: Builtins" })
    set("n", ts_leader .. "gS", ts.git_stash, { silent = true, desc = "Telescope: Git Stash" })
    set("n", ts_leader .. "gb", ts.git_branches, { silent = true, desc = "Telescope: Git Branches" })
    set("n", ts_leader .. "gc", ts.git_commits, { silent = true, desc = "Telescope: Git Commits" })
    set("n", ts_leader .. "gs", ts.git_status, { silent = true, desc = "Telescope: Git Status" })
    set("n", ts_leader .. "help", ts.help_tags, { silent = true, desc = "Telescope: Help Tags" })
    set("n", ts_leader .. "jl", ts.jumplist, { silent = true, desc = "Telescope: Jumplist " })
    set("n", ts_leader .. "man", ts.man_pages, { silent = true, desc = "Telescope: Man Pages " })
    set("n", ts_leader .. "re", ts.resume, { silent = true, desc = "Telescope: Resume " })
    set(
      "n",
      ts_leader .. "rb",
      ts.current_buffer_fuzzy_find,
      { silent = true, desc = "Telescope: Current Buffer Fuzzy Find " }
    )
    set({ "n", "v" }, ts_leader .. "rg", ts.grep, { silent = true, desc = "Telescope: Live Grep " })
    set(
      { "n", "v" },
      ts_leader .. "rG",
      function() ts.grep { cwd = "%:p:h" } end,
      { silent = true, desc = "Telescope: Live Grep (CWD)" }
    )
    set("n", ts_leader .. "ts", ts.treesitter, { silent = true, desc = "Telescope: Treesitter" })
    set("n", "gd", ts.lsp_definitions, { silent = true, desc = "Telescope: LSP Definitions" })
    set("n", "gr", ts.lsp_references, { silent = true, desc = "Telescope: LSP References" })
    set("n", ts_leader .. "sd", ts.lsp_document_symbols, { silent = true, desc = "Telescope: LSP Document Symbols" })
    set(
      "n",
      ts_leader .. "db",
      function() ts.diagnostics { prompt_title = "Document Diagnostics", bufnr = 0 } end,
      { silent = false, desc = "Telescope: Document Diagnostics" }
    )
    set(
      "n",
      ts_leader .. "dw",
      function() ts.diagnostics { prompt_title = "Workspace Diagnostics" } end,
      { silent = true, desc = "Telescope: Workspace Diagnostics" }
    )
    set(
      "n",
      ts_leader .. "cs",
      function() ts.lsp_document_symbols { symbols = "class" } end,
      { silent = true, desc = "Telescope: LSP Class Symbols" }
    )
    set(
      "n",
      ts_leader .. "fs",
      function() ts.lsp_document_symbols { symbols = { "function", "method" } } end,
      { silent = true, desc = "Telescope: LSP Function Symbols" }
    )
    set(
      "n",
      ts_leader .. "ws",
      function() ts.lsp_workspace_symbols { query = vim.fn.input "> " } end,
      { silent = true }
    )
    set(
      "n",
      ts_leader .. "wsd",
      ts.lsp_dynamic_workspace_symbols,
      { silent = true, desc = "Telescope: LSP Dynamic Workspace Symbols " }
    )
  end,
}
