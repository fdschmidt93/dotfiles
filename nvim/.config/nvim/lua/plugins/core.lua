return {
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  {
    "morhetz/gruvbox",
    config = function() require "fds.highlights" end,
  },
  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },
  {
    "romainl/vim-cool",
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
    "norcalli/nvim-colorizer.lua",
    ft = "lua",
    config = function() require("colorizer").setup() end,
  },
  {
    "tpope/vim-repeat",
    event = "InsertEnter",
    config = function() vim.cmd [[silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)]] end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup {
        scope = { show_start = false },
      }
    end,
  },
  -- {
  --   "tpope/vim-surround",
  --   event = "InsertEnter",
  -- },
  { "jbyuki/venn.nvim", event = "ModeChanged" },
}
