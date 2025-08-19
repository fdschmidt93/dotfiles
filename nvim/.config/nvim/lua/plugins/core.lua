return {
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  {
    "morhetz/gruvbox",
    config = function() require "fds.highlights" end,
  },
  {
    "romainl/vim-cool",
  },
  {
    "OXY2DEV/markview.nvim",
    -- lazy = false, -- Recommended
    ft = "markdown", -- If you decide to lazy-load anyway
    config = function()
      require("markview").setup {
        markdown = {
          headings = {
            org_indent = true,
          },
          list_items = {
            enable = true,
            shift_width = 2,
            indent_size = 2,
            marker_minus = { text = "•" },
          },
        },
        preview = {
          modes = { "n", "no", "c" },
          callbacks = {
            on_enable = function(_, win)
              vim.wo[win].conceallevel = 2
              vim.wo[win].concealcursor = "nc"
            end,
          },
          hybrid_modes = { "n" },
        },
        latex = { enable = true },
        html = {
          enable = true,
          tags = {
            enable = true,
            default = { conceal = true, hl = nil },
            configs = {
              u = { conceal = true, hl = "@markup.underline" },
            },
          },
        },
      }
    end,
  },
  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    "nvim-treesitter/nvim-treesitter",

    "nvim-tree/nvim-web-devicons",
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
    event = "VeryLazy",
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
  {
    "tpope/vim-surround",
    event = "VeryLazy",
  },
}
