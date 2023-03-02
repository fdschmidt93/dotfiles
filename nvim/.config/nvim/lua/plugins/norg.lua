return {
  "nvim-neorg/neorg",
  ft = "norg",
  dependencies = { "nvim-treesitter", "plenary.nvim", "nvim-cmp" },
  config = function()
    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

    parser_configs.norg = {
      install_info = {
        url = "https://github.com/vhyrro/tree-sitter-norg",
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main",
      },
    }
    parser_configs.norg_meta = {
      install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
        files = { "src/parser.c" },
        branch = "main",
      },
    }

    parser_configs.norg_table = {
      install_info = {
        url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
        files = { "src/parser.c" },
        branch = "main",
      },
    }

    require("neorg").setup {
      load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader>o",
          },
        },
        ["core.norg.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        ["core.norg.concealer"] = {},
      },
    }
  end,
}
