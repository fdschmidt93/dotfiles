local ts_picker = require "plugins.snacks.treesitter"
local snacks_actions = require "plugins.snacks.actions"
local leader = "<space><space>"

local insert_selection = function(picker, _, _)
  local items = picker:selected { fallback = true }
  if #items == 0 then
    vim.notify("No items selected", vim.log.levels.WARN)
    return
  end

  local wins = vim.api.nvim_list_wins()
  local copilot
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "copilot-chat" then
      copilot = win
      break
    end
  end

  if copilot ~= nil then
    picker:close()
    vim.schedule(function()
      vim.api.nvim_set_current_win(copilot)
      local lines = {}
      for _, item in ipairs(items) do
        table.insert(lines, "#file:" .. item.file)
      end
      vim.api.nvim_put(lines, "c", true, true)
    end)
  else
    vim.notify("No copilot-chat window found", vim.log.levels.WARN)
  end
end

return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    image = {
      doc = {
        inline = true,
      },
    },
    picker = {
      win = {
        input = {
          keys = {
            ["<A-Down>"] = { "history_forward", mode = { "i", "n" } },
            ["<A-Up>"] = { "history_back", mode = { "i", "n" } },
          }
        }
      },
      sources = {
        explorer = {
          actions = {
            open_subdirs = { action = snacks_actions.open_subdirs, desc = "Open sub-dirs" },
            collapse_subdirs = { action = snacks_actions.collapse_subdirs, desc = "Collapse sub-dirs" },
          },
          win = {
            input = {
              keys = {
                [">"] = { "open_subdirs", mode = { "i", "n" } },
                ["<"] = { "collapse_subdirs", mode = { "i", "n" } },
                ["/"] = { "focus_list", mode = { "i", "n" } },
              },
            },
            list = {
              keys = {
                [">"] = { "open_subdirs", mode = { "i", "n" } },
                ["<"] = { "collapse_subdirs", mode = { "i", "n" } },
              },
            },
          },
        },
        files = {
          actions = {
            insert_selection = { action = insert_selection, desc = "Insert selected file name" },
            oil = { action = snacks_actions.open_in_oil, desc = "Open Oil" },

          },
          win = {
            input = {
              keys = {
                ["<C-z>"] = { "insert_selection", mode = { "n", "i" } },
                ["<a-s>"] = { "oil", mode = { "i", "n" } },
              },
            },
          },
        },
        my_treesitter = {
          finder = ts_picker.finder,
          live = false,
          format = ts_picker.formatter,
          actions = {
            send_to_repl = { action = ts_picker.send_to_repl, desc = "send_to_repl" },
          },
          win = {
            input = {
              keys = {
                ["<a-s>"] = { "send_to_repl", mode = { "i", "n" } },
              },
            },
          },
        },
        -- select = {
        --   layout = {
        --     preset = "vscode",
        --   },
        -- },
        egrep = {
          finder = require "plugins.snacks.egrep",
          format = "file",
          live = true, -- live grep by default
          supports_live = true,
        },
      },
      layouts = {
        default = {
          layout = {
            backdrop = false,
            row = 1,
            width = 0.9999,
            height = 0.9999,
            box = "vertical",
            { win = "preview", height = 0.4, border = "rounded" },
            {
              box = "vertical",
              border = "rounded",
              title = "{source} {live}",
              title_pos = "center",
              { win = "input", height = 1,     border = "bottom" },
              { win = "list",  border = "none" },
            },
          },
        },
      },
    },
  },
  keys = {
    {
      leader .. "rg",
      function() Snacks.picker.egrep() end,
      mode = { "n", "v" },
      desc = "Egrepify",
    },
    {
      leader .. "ff",
      function() Snacks.picker.files() end,
      mode = { "n", "v" },
      desc = "Snacks: Find Files",
    },

    -- Buffers
    { leader .. "bb", function() Snacks.picker.buffers() end,                       desc = "Snacks: Buffers" },

    { leader .. "bf", function() Snacks.picker.explorer { cwd = vim.uv.cwd() } end, desc = "Snacks: Explorer" },
    {
      leader .. "bF",
      function() Snacks.picker.explorer() end,
      desc = "Snacks: Explorer",
    },

    { leader .. "ts",   function() Snacks.picker.my_treesitter() end,   desc = "Snacks: Treesitter" },

    -- Current buffer fuzzy find
    { leader .. "rb",   function() Snacks.picker.lines() end,           desc = "Snacks: Current Buffer Lines" },

    -- Git
    { leader .. "gc",   function() Snacks.picker.git_log() end,         desc = "Snacks: Git Commits" },
    { leader .. "gs",   function() Snacks.picker.git_status() end,      desc = "Snacks: Git Status" },
    -- There's no built-in Snacks “git_stash” or “git_branches” yet; remove or create custom.

    -- Help / Man
    { leader .. "help", function() Snacks.picker.help() end,            desc = "Snacks: Help Pages" },
    { leader .. "man",  function() Snacks.picker.man() end,             desc = "Snacks: Man Pages" },

    -- Jumplist
    { leader .. "jl",   function() Snacks.picker.jumps() end,           desc = "Snacks: Jump List" },

    -- Resume last Snacks picker
    { leader .. "re",   function() Snacks.picker.resume() end,          desc = "Snacks: Resume" },

    -- LSP
    { "gd",             function() Snacks.picker.lsp_definitions() end, desc = "Snacks: LPS Go To Definition" },
    { "gr",             function() Snacks.picker.lsp_references() end,  desc = "Snacks: LSP References" },
    { leader .. "ds",   function() Snacks.picker.lsp_symbols() end,     desc = "Snacks: LSP Symbols" },
    -- You can add gI / gy, etc. if desired:

    -- Diagnostics
    { leader .. "bd",   function() Snacks.picker.diagnostics() end,     desc = "Snacks: Diagnostics (Buffer)" },
  },
}
