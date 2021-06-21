local use = require("packer").use
local prog_ft = { "lua", "python" }

require("packer").startup(function()
  -- Packer can manage itself as an optional plugin
  use { "wbthomason/packer.nvim" }
  use "edluffy/hologram.nvim"

  -- theme & icons
  use {
    "morhetz/gruvbox",
    config = function()
      require "highlights"
    end,
  }
  use "kyazdani42/nvim-web-devicons"

  -- meta plugins
  use "tjdevries/astronauta.nvim"
  use {
    "antoinemadec/FixCursorHold.nvim",
    config = function()
      vim.g.cursorhold_updatetime = 500
    end,
    event = "CursorMoved",
  }

  -- tools
  use { "tpope/vim-commentary", keys = "gc" }
  use { "romainl/vim-cool", keys = "/" }
  use { "tpope/vim-surround", event = "InsertEnter" }

  -- filetype plugins
  use { "chrisbra/csv.vim", ft = "csv" }
  use {
    "vimwiki/vimwiki",
    ft = "markdown",
    config = function()
      vim.cmd [[let g:vimwiki_global_ext = 1]]
      vim.cmd [[let g:vimwiki_conceallevel = 2]]
    end,
  }
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = "markdown",
    cmd = "MarkdownPreview",
  }
  use {
    "lervag/vimtex",
    ft = "tex",
    config = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_fold_manual = 1
      vim.g.vimtex_latexmk_continuous = 1
      vim.g.vimtex_compiler_progname = "nvr"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      vim.wo.conceallevel = 2
      vim.g.tex_conceal = "abdgm"
    end,
  }

  use {
    "lukas-reineke/indent-blankline.nvim",
    -- TODO check why it cannot be linked to programming filetypes
    config = function()
      vim.g.indent_blankline_filetype = { "python", "lua" }
      vim.g.indentLine_char = "│"
      vim.g.indent_blankline_show_current_context = true
    end,
    branch = "lua",
  }

  -- git
  use { "tpope/vim-fugitive", cmd = "Git" }
  use {
    "TimUntersberger/neogit",
    -- lazy load with key combination
    keys = "<A-n>",
    config = function()
      require("neogit").setup {
        integrations = { diffview = true },
        signs = {
          section = { "", "" }, -- "", ""
          item = { "▸", "▾" },
          hunk = { "樂", "" },
        },
      }
      nnoremap { "<A-n>", [[<cmd>Neogit<CR>]], { silent = true } }
    end,
    requires = { "sindrets/diffview.nvim", "nvim-lua/plenary.nvim" },
  }
  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    -- lazy load only once a proper buffer has been loaded
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup()
    end,
  }

  -- floating window preview for quickfix list
  use {
    "kevinhwang91/nvim-bqf",
    keys = "<C-q>",
    config = function()
      -- toggle qf window
      nnoremap { "<C-q>", require("utils").toggle_qf, { silent = true } }
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    filetype = { "python", "lua", "markdown" },
    run = ":TSUpdate",
    config = function()
      require "plugins.treesitter"
    end,
  }
  use {
    "nvim-treesitter/nvim-treesitter-textobjects",
    requires = "nvim-treesitter",
  }
  use {
    "nvim-treesitter/nvim-treesitter-refactor",
    requires = "nvim-treesitter",
  }
  use {
    "justinmk/vim-sneak",
    config = function()
      vim.cmd [[let g:sneak#label = 1]]
      vim.api.nvim_set_keymap("", "f", "<Plug>Sneak_f", {})
      vim.api.nvim_set_keymap("", "F", "<Plug>Sneak_F", {})
      vim.api.nvim_set_keymap("", "t", "<Plug>Sneak_t", {})
      vim.api.nvim_set_keymap("", "T", "<Plug>Sneak_T", {})
    end,
  }
  use {
    "phaazon/hop.nvim",
    after = { "gruvbox", "vim-sneak" },
    -- keys = {'<C-s>', '<C-f>', '<C-l>', [[<C-/>]]},
    config = function()
      for _, map in pairs { nnoremap, vnoremap } do
        map { "<C-s>", require("hop").hint_char2 }
        map { "<C-f>", require("hop").hint_char1 }
        map { "<C-l>", require("hop").hint_lines }
        map { "<C-/>", require("hop").hint_patterns }
      end
      -- hl groups
      local palette = require "highlights.gruvbox"
      local utils = require "utils"
      local highlights = {
        { "HopNextKey", { fg = palette.bright_orange, gui = "bold,underline" } },
        { "HopNextKey1", { fg = palette.bright_green, gui = "bold,underline" } },
        { "HopNextKey2", { fg = palette.neutral_green } },
        { "HopUnmatched", { fg = palette.light4 } },
      }
      for _, hl in pairs(highlights) do
        utils.set_hl(hl[1], hl[2])
      end
    end,
  }
  -- REPL for vim
  use {
    "jpalardy/vim-slime",
    config = function()
      vim.g.slime_target = "neovim"
      vim.g.slime_python_ipython = 1
    end,
  }
  -- enable repeating supported plugin maps with dot
  use {
    "tpope/vim-repeat",
    event = "InsertEnter",
    config = function()
      vim.cmd [[silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)]]
    end,
  }
  use {
    "glepnir/galaxyline.nvim",
    branch = "main",
    config = function()
      require "plugins.statusline"
    end,
  }

  use {
    "akinsho/nvim-bufferline.lua",
    after = "gruvbox",
    config = function()
      require("bufferline").setup {
        options = {
          view = "multiwindow",
          numbers = "ordinal",
          number_style = "superscript",
          mappings = true,
          tab_size = 18,
          show_buffer_close_icons = false,
          separator_style = "thin",
          enforce_regular_tabs = true,
        },
      }
    end,
  }
  -- for extremely large code- and databases
  use {
    "junegunn/fzf.vim",
    keys = "<space><space>zrg",
    config = function()
      nnoremap { "<space><space>zrg", "<cmd>Rg<CR>", { silent = true } }
    end,
  }
  use {
    "norcalli/nvim-colorizer.lua",
    after = "gruvbox",
    ft = "lua",
    config = function()
      require("colorizer").setup()
    end,
  } -- show hex rgb colors
  use {
    "kkoomen/vim-doge",
    ft = prog_ft,
    run = ":call doge#install()",
    config = function()
      vim.g.doge_enable_mappings = 1
    end,
  }
  use {
    -- 'nvim-telescope/telescope.nvim',
    "~/repos/lua/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = function()
      require "plugins.telescope"
    end,
  }
  use {
    "mfussenegger/nvim-dap",
    after = { "gruvbox", "telescope.nvim" },
    ft = prog_ft,
    requires = {
      "nvim-telescope/telescope-dap.nvim",
      requires = "telescope.nvim",
    },
    config = function()
      local opts = { silent = true }
      nnoremap { "<F5>", require("dap").continue, opts }
      nnoremap { "<F10>", require("dap").step_over, opts }
      nnoremap { "<F11>", require("dap").step_into, opts }
      nnoremap { "<F12>", require("dap").step_out, opts }
      nnoremap { "<space>b", require("dap").toggle_breakpoint, opts }
      nnoremap { "<space>dr", require("dap").repl.open, opts }
      nnoremap { "<space>dl", require("dap").run_last, opts }
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Breakpoint" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "Stopped" })
      require("telescope").load_extension "dap"
    end,
  }
  use {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    after = "nvim-dap",
    config = function()
      local python_path = string.format("/home/%s/miniconda3/bin/python", os.getenv "USER")
      require("dap-python").setup(python_path)
    end,
  }

  use {
    "neovim/nvim-lspconfig",
    ft = prog_ft,
    requires = {
      "glepnir/lspsaga.nvim",
      "ray-x/lsp_signature.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require "plugins.lspconfig"
    end,
  }
  use {
    "hrsh7th/nvim-compe",
    -- load compe only after entering insert mode
    event = "InsertEnter",
    config = function()
      vim.o.completeopt = "menuone,noselect"
      require("compe").setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = "disable",
        throttle_time = 0,
        source_timeout = 200,
        incomplete_delay = 400,
        allow_prefix_unmatch = false,
        source = {
          path = true,
          buffer = true,
          vsnip = false,
          nvim_lsp = true,
          treesitter = true,
        },
      }
    end,
  }

  use {
    "kyazdani42/nvim-tree.lua",
    as = "nvim-tree",
    requires = "kyazdani42/nvim-web-devicons",
    keys = "<A-m>",
    config = function()
      nnoremap { "<A-m>", [[<cmd>NvimTreeToggle<CR>]], { silent = true } }
      vim.g.nvim_tree_indent_markers = 1
      vim.g.nvim_tree_highlight_opened_files = 1
      -- vim.g.nvim_tree_git_hl = 1
    end,
  }
end)
