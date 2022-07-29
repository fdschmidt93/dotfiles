local fn = vim.fn
local HOME = vim.loop.os_homedir()

-- attempt to find local repo, otherwise fallback to git
local use_local = function(path, fallback)
  if path:sub(1, 1) == "~" then
    path = HOME .. path:sub(2, -1)
  end
  if fn.isdirectory(path) == 1 then
    return path
  else
    return fallback
  end
end

local modules = {
  { "wbthomason/packer.nvim" },
  { use_local("~/repos/lua/plenary.nvim", "nvim-lua/plenary.nvim") },
  --- Utilities{{{
  { "lewis6991/impatient.nvim" },
  {
    "rcarriga/nvim-notify",
    requires = "plenary.nvim",
    config = function()
      vim.notify = require "notify"
    end,
  },
  {
    "stevearc/dressing.nvim",
    config = function()
      require "fds.plugins.dressing"
    end,
  },
  { "nanotee/luv-vimdocs" },
  { "romainl/vim-cool" },
  {
    "antoinemadec/FixCursorHold.nvim",
    config = function()
      vim.g.cursorhold_updatetime = 500
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "InsertEnter",
    config = function()
      require("nvim-surround").setup {
        delimiters = {
          pairs = {
            ["*"] = { "*", "*" },
            ["_"] = { "_", "_" },
          },
        },
      }
    end,
  },
  {
    "ggandor/leap.nvim",
    after = "gruvbox",
    config = function()
      require("leap").set_default_keymaps()
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
--}}}
  --- Theme, Status- & Bufferline{{{
  {
    "morhetz/gruvbox",
    config = function()
      require "fds.highlights"
    end,
  },
  { "kyazdani42/nvim-web-devicons" },
  {
    "glepnir/galaxyline.nvim",
    branch = "main",
    config = function()
      require "fds.plugins.galaxyline"
    end,
  },
  {
    "akinsho/nvim-bufferline.lua",
    after = "gruvbox",
    config = function()
      require "fds.plugins.bufferline"
    end,
  },--}}}
  --- Filetype{{{
  { "chrisbra/csv.vim", ft = "csv" },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require("rust-tools").setup {}
    end,
    requires = "plenary.nvim",
  },--}}}
  --- Git{{{
  {
    "lewis6991/gitsigns.nvim",
    requires = { "plenary.nvim" },
    config = function()
      require "fds.plugins.gitsigns"
    end,
  },
  {
    "tpope/vim-fugitive",
    keys = "<A-N>",
    config = function()
      vim.keymap.set("n", "<A-N>", [[<cmd>Git<CR>]], { silent = true })
      vim.keymap.set("n", "<A-a>", [[<cmd>diffget //2<CR>]], { silent = true })
      vim.keymap.set("n", "<A-d>", [[<cmd>diffget //3<CR>]], { silent = true })
    end,
  },
  {
    "TimUntersberger/neogit",
    keys = "<A-n>",
    config = function()
      require("neogit").setup {
        integrations = { diffview = true },
        signs = {
          section = { "", "" },
          item = { "▸", "▾" },
          hunk = { "樂", "" },
        },
      }
      vim.keymap.set("n", "<A-n>", [[<cmd>Neogit<CR>]], { silent = true })
    end,
    requires = { "sindrets/diffview.nvim", "plenary.nvim" },
  },--}}}
  --- Treesitter{{{
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require "fds.plugins.treesitter"
    end,
  },
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle", requires = { "nvim-treesitter" } },
  {
    use_local("~/repos/lua/resin.nvim/", "fdschmidt93/resin.nvim"),
    config = function()
      require "fds.plugins.resin"
    end,
  },
--}}}
  --- Telescope{{{
  {
    use_local("~/repos/lua/telescope.nvim", "nvim-telescope/telescope.nvim"),
    requires = {
      "plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-symbols.nvim" },
      { "nvim-telescope/telescope-smart-history.nvim", requires = "kkharji/sqlite.lua" },
      use_local("~/repos/lua/telescope-file-browser.nvim", "nvim-telescope/telescope-file-browser.nvim"),
    },
    config = function()
      require "fds.plugins.telescope"
    end,
  },
--}}}
  --- LSP & Autocompletion{{{
  {
    "neovim/nvim-lspconfig",
    requires = {
      "folke/lua-dev.nvim",
    },
    config = function()
      require "fds.plugins.lspconfig"
    end,
  },
  { "jose-elias-alvarez/null-ls.nvim", requires = { "plenary.nvim", "neovim/nvim-lspconfig" } },
  {
    "L3MON4D3/LuaSnip",
    opt = true,
    config = function()
      require "fds.plugins.luasnip"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    after = "gruvbox",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-omni",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-rg",
    },
    config = function()
      require("packer").loader "LuaSnip"
      require "fds.plugins.cmp"
    end,
  },
--}}}
  --- Programming{{{
  {
    "mfussenegger/nvim-dap",
    ft = { "python", "rust", "lua" },
    requires = {
      "nvim-telescope/telescope-dap.nvim",
      { "rcarriga/nvim-dap-ui", opt = true },
      { "mfussenegger/nvim-dap-python", opt = true },
    },
    config = function()
      require("packer").loader("nvim-dap-ui", "nvim-dap-python")
      require "fds.plugins.dap"
    end,
  },
  {
    "kkoomen/vim-doge",
    run = ":call doge#install()",
    config = function()
      vim.g.doge_enable_mappings = 1
      vim.g.doge_doc_standard_python = "google"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "fds.plugins.indentline"
    end,
  },
--}}}
  --- Writing{{{
  {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      require "fds.plugins.norg"
    end,
  },
  {
    "nvim-neorg/neorg",
    ft = "norg",
    after = "nvim-treesitter",
    config = function()
      require "fds.plugins.norg"
    end,
    requires = { "plenary.nvim" },
  },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = "markdown",
  },--}}}
}

require("packer").startup { modules }

-- vim:ts=4:sw=4:ai:foldmethod=marker:foldlevel=0:
