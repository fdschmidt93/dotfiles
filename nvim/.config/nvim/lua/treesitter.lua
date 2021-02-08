require "nvim-treesitter.configs"
require "nvim-treesitter.configs".setup(
    {
        highlight = {
            enable = true -- false will disable the whole extension
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            -- this enables incremental selection
            enable = true,
            disable = {},
            keymaps = {
                init_selection = "<enter>", -- maps in normal mode to init the node/scope selection
                node_incremental = "<enter>", -- increment to the upper named parent
                scope_incremental = "Ts", -- increment to the upper scope 
                node_decremental = "grm"
            }
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
                select_current_node = "<leader>ff"
            }
        },
        textobjects = {
            select = {
                enable = true,
                disable = {},
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["aC"] = "@class.outer",
                    ["iC"] = "@class.inner",
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
                    ["im"] = "@call.inner"
                },
            },
        },
        fold = {
            enable = true
        },
        refactor = {
            highlight_current_scope = {
                enable = false,
                inverse_highlighting = true,
                disable = {"python"}
            },
            highlight_definitions = {
                enable = true,
            },
            smart_rename = {
                enable = true,
                disable = {},
                keymaps = {
                    smart_rename = "grr"
                }
            },
            navigation = {
                enable = true,
                disable = {},
                keymaps = {
                    goto_definition = "gnd",
                    list_definitions = "gnD",
                    list_definitions_toc = "gO",
                    goto_next_usage = "<a-*>",
                    goto_previous_usage = "<a-#>",
                }
            }
        },
        ensure_installed = "all"
    }
)

require "nvim-treesitter.highlight"
local hlmap = vim.treesitter.highlighter.hl_map

--Misc
hlmap.error = nil
hlmap["punctuation.delimiter"] = "Delimiter"
hlmap["punctuation.bracket"] = "Delimiter"

-- Constants
hlmap["constant"] = "Constant"
hlmap["constant.builtin"] = "Type"
hlmap["constant.macro"] = "Define"
hlmap["string"] = "String"
hlmap["string.regex"] = "String"
hlmap["string.escape"] = "SpecialChar"
hlmap["character"] = "Character"
hlmap["number"] = "Number"
hlmap["boolean"] = "Boolean"
hlmap["float"] = "Float"

-- Functions
hlmap["function.builtin"] = "Special"
hlmap["function.macro"] = "Macro"
hlmap["parameter"] = "Identifier"
hlmap["property"] = "Identifier"
hlmap["constructor"] = "Type"

hlmap["function"] = "Function"
hlmap["field"] = "Identifier"
hlmap["method"] = "Function"

-- Keywords
hlmap["conditional"] = "Conditional"
hlmap["repeat"] = "Repeat"
hlmap["label"] = "Label"
hlmap["operator"] = "Operator"
hlmap["keyword"] = "Repeat"
hlmap["exception"] = "Exception"
hlmap["include"] = "Include"
hlmap["type"] = "Type"
hlmap["type.builtin"] = "Type"
hlmap["structure"] = "Structure"
