return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    -- takes 15ms of startup
    vim.defer_fn(function()
      require("nvim-treesitter.configs").setup {
        highlight = {
          enable = true, -- false will disable the whole extension
          additional_vim_regex_highlighting = { "org" },
        },
        indent = { enable = true, disable = { "python" } },
        incremental_selection = {
          -- this enables incremental selection
          enable = true,
          disable = {},
          keymaps = {
            init_selection = "<S-Right>", -- maps in normal mode to init the node/scope selection
            node_incremental = "<S-Right>", -- increment to the upper named parent
            scope_incremental = "<S-Up>", -- increment to the upper scope
            node_decremental = "<S-Left>",
          },
        },
        node_movement = {
          -- this enables incremental selection
          enable = true,
          highlight_current_node = true,
          disable = {},
          keymaps = {
            move_up = "<a-k>",
            move_down = "<a-j>",
            move_left = "<a-h>",
            move_right = "<a-l>",
            swap_up = "<s-a-k>",
            swap_down = "<s-a-j>",
            swap_left = "<s-a-h>",
            swap_right = "<s-a-l>",
            select_current_node = "<leader>ff",
          },
        },
        textobjects = {
          select = {
            enable = true,
            disable = {},
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ao"] = "@class.outer",
              ["io"] = "@class.inner",
              ["ac"] = "@conditional.outer",
              ["ic"] = "@conditional.inner",
              ["ae"] = "@block.outer",
              ["ie"] = "@block.inner",
              ["al"] = "@loop.outer",
              ["il"] = "@loop.inner",
              ["is"] = "@statement.inner",
              ["as"] = "@statement.outer",
              ["ad"] = "@comment.outer",
              ["id"] = "@comment.inner",
              ["am"] = "@call.outer",
              ["im"] = "@call.inner",
            },
          },
        },
        fold = { enable = true },
        refactor = {
          highlight_current_scope = {
            enable = false,
            inverse_highlighting = true,
            disable = { "python" },
          },
          highlight_definitions = { enable = true },
          smart_rename = { enable = true, disable = {}, keymaps = { smart_rename = "grr" } },
        },
        ensure_installed = "all",
      }

      -- ensure python vi[f,o] selection is line-wise for repl
      vim.keymap.set("o", "iF", ":normal Vif<CR>")
      vim.keymap.set("o", "iO", ":normal Vio<CR>")

      -- code injections for rst docs: https://github.com/nvim-treesitter/nvim-treesitter/pull/2168
      require("vim.treesitter.query").set_query(
        "python",
        "injections",
        [[
; Class docstring
((class_definition
  body: (block . (expression_statement (string) @rst)))
 (#offset! @rst 0 3 0 -3))

; Function/method docstring
((function_definition
  body: (block . (expression_statement (string) @rst)))
 (#offset! @rst 0 3 0 -3))

 ; Attribute docstring
(((expression_statement (assignment)) . (expression_statement (string) @rst))
 (#offset! @rst 0 3 0 -3))
]]
      )
    end, 20)
  end,
}, { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle", dependencies = { "nvim-treesitter" } }
