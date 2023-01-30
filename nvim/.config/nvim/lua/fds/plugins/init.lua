local fn = vim.fn
local HOME = vim.loop.os_homedir()

-- attempt to find local repo, otherwise fallback to git
local use_local = function(path, fallback, opts)
  opts = opts or {}
  if path:sub(1, 1) == "~" then
    path = HOME .. path:sub(2, -1)
  end
  if fn.isdirectory(path) == 1 then
    opts.dir = path
  else
    opts[1] = fallback
  end
  return opts
end

local modules = {
  use_local("~/repos/lua/plenary.nvim", "nvim-lua/plenary.nvim"),
  --- Utilities{{{
  { "jbyuki/venn.nvim", event = "ModeChanged" },
  {
    "rcarriga/nvim-notify",
    dependencies = "plenary.nvim",
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
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      require("hlslens").setup()
    end,
  },
  { "romainl/vim-cool" },
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
    "tpope/vim-surround",
    event = "InsertEnter",
  },
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    dependencies = "gruvbox",
    config = function()
      require("leap").set_default_keymaps()
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "plenary.nvim",
      "nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup {
        window = {
          mappings = {
            ["A"] = { "expand_all_nodes" },
          },
        },
      }
    end,
  },
  {
    "ggandor/flit.nvim",
    keys = { "f", "F", "t", "T" },
    dependencies = { "leap.nvim" },
    config = function()
      require("flit").setup {
        keys = { f = "f", F = "F", t = "t", T = "T" },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = "nv",
        multiline = true,
        -- Like `leap`s similar argument (call-specific overrides).
        -- E.g.: opts = { equivalence_classes = {} }
        opts = {},
      }
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
    dependencies = "gruvbox",
    config = function()
      require "fds.plugins.bufferline"
    end,
  }, --}}}
  --- Filetype{{{
  { "chrisbra/csv.vim", ft = "csv" },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
      require("rust-tools").setup {
        server = {
          capabilities = capabilities,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                allFeatures = true,
                overrideCommand = {
                  "cargo",
                  "clippy",
                  "--workspace",
                  "--message-format=json",
                  "--all-targets",
                  "--all-features",
                },
              },
            },
          },
        },
      }
    end,
    dependencies = "plenary.nvim",
  }, --}}}
  --- Git{{{
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "plenary.nvim" },
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
    dependencies = { "sindrets/diffview.nvim", "plenary.nvim" },
  }, --}}}
  --- Treesitter{{{
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require "fds.plugins.treesitter"
    end,
  },
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle", dependencies = { "nvim-treesitter" } },
  use_local("~/repos/lua/resin.nvim/", "fdschmidt93/resin.nvim", {
    config = function()
      require "fds.plugins.resin"
    end,
  }),
  --}}}
  --- Telescope{{{
  {
    "ibhagwan/fzf-lua",
    setup = function()
      require("fzf-lua").setup {
        preview = {
          layout = "horizontal",
        },
      }
    end,
  },
  {
    dir = "/home/fdschmidt/repos/lua/telescope.nvim",
    -- cmd = "Telescope",
    -- keys = "<Space>",
    dependencies = {
      "plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-symbols.nvim" },
      { "nvim-telescope/telescope-smart-history.nvim", dependencies = "kkharji/sqlite.lua" },
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
    dependencies = {
      "folke/neodev.nvim",
    },
    config = function()
      require "fds.plugins.lspconfig"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "plenary.nvim", "neovim/nvim-lspconfig" },
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    config = function()
      require "fds.plugins.luasnip"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "gruvbox",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-omni",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-rg",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require "fds.plugins.cmp"
    end,
  },
  --}}}
  --- Programming{{{
  {
    "mfussenegger/nvim-dap",
    keys = "<space>D",
    dependencies = {
      "nvim-telescope/telescope-dap.nvim",
      { "rcarriga/nvim-dap-ui" },
      { "mfussenegger/nvim-dap-python" },
    },
    config = function()
      require "fds.plugins.dap"
    end,
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
      require "fds.plugins.indentline"
    end,
  },
  --}}}
  --- Writing{{{
  {
    "lervag/vimtex",
    ft = "tex",
  },
  {
    "nvim-neorg/neorg",
    ft = "norg",
    dependencies = { "nvim-treesitter", "plenary.nvim", "nvim-cmp" },
    config = function()
      require "fds.plugins.norg"
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
  }, --}}}
}

require("lazy").setup(modules)

-- vim:ts=4:sw=4:ai:foldmethod=marker:foldlevel=0:
