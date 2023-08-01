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
  { "dhruvasagar/vim-table-mode",  ft = "markdown" },
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
    "rcarriga/nvim-notify",
    dependencies = "plenary.nvim",
    config = function()
      vim.notify = require "notify"
    end,
  },
}
