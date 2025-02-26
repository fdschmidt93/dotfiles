local ts_picker = require "plugins.snacks.treesitter"
local snacks_actions = require "plugins.snacks.actions"
local leader = "<space><space>"

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
            oil = { action = snacks_actions.open_in_oil, desc = "Open Oil" },
          },
          win = {
            input = {
              keys = {
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
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
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
    { leader .. "bb", function() Snacks.picker.buffers() end, desc = "Snacks: Buffers" },

    { leader .. "bf", function() Snacks.picker.explorer { cwd = vim.uv.cwd() } end, desc = "Snacks: Explorer" },
    {
      leader .. "bF",
      function() Snacks.picker.explorer() end,
      desc = "Snacks: Explorer",
    },

    { leader .. "ts", function() Snacks.picker.my_treesitter() end, desc = "Snacks: Treesitter" },

    -- Current buffer fuzzy find
    { leader .. "rb", function() Snacks.picker.lines() end, desc = "Snacks: Current Buffer Lines" },

    -- Git
    { leader .. "gc", function() Snacks.picker.git_log() end, desc = "Snacks: Git Commits" },
    { leader .. "gs", function() Snacks.picker.git_status() end, desc = "Snacks: Git Status" },
    -- There's no built-in Snacks “git_stash” or “git_branches” yet; remove or create custom.

    -- Help / Man
    { leader .. "help", function() Snacks.picker.help() end, desc = "Snacks: Help Pages" },
    { leader .. "man", function() Snacks.picker.man() end, desc = "Snacks: Man Pages" },

    -- Jumplist
    { leader .. "jl", function() Snacks.picker.jumps() end, desc = "Snacks: Jump List" },

    -- Resume last Snacks picker
    { leader .. "re", function() Snacks.picker.resume() end, desc = "Snacks: Resume" },

    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Snacks: LPS Go To Definition" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "Snacks: LSP References" },
    { leader .. "ds", function() Snacks.picker.lsp_symbols() end, desc = "Snacks: LSP Symbols" },
    -- You can add gI / gy, etc. if desired:

    -- Diagnostics
    { leader .. "bd", function() Snacks.picker.diagnostics() end, desc = "Snacks: Diagnostics (Buffer)" },
  },
}
