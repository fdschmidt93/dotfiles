return {
  {
    "romainl/vim-cool",
  },
  {
    "morhetz/gruvbox",
    config = function()
      require "fds.highlights"
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
  },
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    config = function()
      vim.g.doge_enable_mappings = 1
      vim.g.doge_doc_standard_python = "google"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.g.indent_blankline_char = "│" --  "▏"
      vim.g.indent_blankline_show_current_context = true
      vim.g.indent_blankline_context_char = "│" --  "▏"
      vim.g.indent_blankline_filetype_exclude = {
        "lspinfo",
        "packer",
        "checkhealth",
        "help",
        "man",
        "norg",
      }
    end,
  },
  { "nvim-lua/plenary.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "glacambre/firenvim",
    build = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    ft = "lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "tpope/vim-repeat",
    event = "InsertEnter",
    config = function()
      vim.cmd [[silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)]]
    end,
  },
  {
    "tpope/vim-surround",
    event = "InsertEnter",
  },
  { "jbyuki/venn.nvim", event = "ModeChanged" },

  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      }
    end,
  },
  {
    "rcarriga/nvim-notify",
    dependencies = "plenary.nvim",
    config = function()
      vim.notify = require "notify"
    end,
  },
}
