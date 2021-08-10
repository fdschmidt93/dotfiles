local use = require("packer").use
local use_rocks = require("packer").use_rocks

local prog_ft = { "lua", "python" }

require("packer").startup(function()
  -- Packer can manage itself as an optional plugin
  use { "wbthomason/packer.nvim" }

  -- theme & icons
  use {
    "morhetz/gruvbox",
    config = function()
      require "highlights"
    end,
  }
  use "kyazdani42/nvim-web-devicons"
  use "tami5/sql.nvim"

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
  use { "romainl/vim-cool" }
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
    -- ft = "markdown",
    -- cmd = "MarkdownPreview",
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
    opt = true,
    config = function()
      vim.g.indent_blankline_filetype = { "python", "lua" }
      vim.g.indent_blankline_char = "│"
      vim.g.indent_blankline_show_current_context = true
    end,
  }

  -- git
  use { "tpope/vim-fugitive", cmd = "Git" }
  use {
    "TimUntersberger/neogit",
    -- lazy load with key combination
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
    opt = true,
    requires = { "nvim-lua/plenary.nvim" },
    -- lazy load only once a proper buffer has been loaded
    config = function()
      require("gitsigns").setup()
    end,
  }

  use {
    "pwntester/octo.nvim",
    opt = true,
    config = function()
      require("octo").setup()
    end,
  }

  -- floating window preview for quickfix list
  use {
    "kevinhwang91/nvim-bqf",
    keys = "<C-q>",
    config = function()
      -- toggle qf window
      nnoremap {
        "<C-q>",
        require("utils").toggle_qf,
        { silent = true },
      }
    end,
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    filetype = { "python", "lua", "markdown" },
    run = ":TSUpdate",
    opt = true,
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- "nvim-treesitter/nvim-treesitter-refactor",
    },
    config = function()
      require "plugins.treesitter"
    end,
  }
  use {
    "nvim-treesitter/playground",
    requires = "nvim-treesitter",
    run = ":TSInstall query",
    config = function()
      require("nvim-treesitter.configs").setup {
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      }
    end,
    cmd = "TSPlaygroundToggle",
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
    opt = true,
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
    opt = true,
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
    opt = true,
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
    "~/repos/lua/telescope.nvim",
    -- "nvim-telescope/telescope.nvim",
    -- load on tele leader
    opt = true,
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      "~/repos/lua/telescope-hop.nvim",
    },
    config = function()
      require "plugins.telescope"
    end,
  }
  use {
    "mfussenegger/nvim-dap",
    opt = true,
    requires = {
      "nvim-telescope/telescope-dap.nvim",
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
      "ray-x/lsp_signature.nvim",
      { "folke/lua-dev.nvim"},
    },
    config = function()
      require "plugins.lsp"
      -- ensure lazyloading pyright works
      if vim.bo.filetype == "python" then
        require("lspconfig")["pyright"].manager.try_add()
      end
    end,
  }
  use {
    "simrat39/symbols-outline.nvim",
    keys = "<space>so",
    config = function()
      vim.g.symbols_outline = {
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = true,
        position = "right",
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        keymaps = {
          close = "<Esc>",
          goto_location = "<Cr>",
          focus_location = "o",
          hover_symbol = "<C-space>",
          rename_symbol = "r",
          code_actions = "a",
        },
        lsp_blacklist = {},
      }
      nnoremap { "<space>so", "<cmd>SymbolsOutline<CR>", { silent = true } }
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
        documentation = {
          border = "rounded", -- the border option is the same as `|help nvim_open_win|`
          winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
          max_width = 120,
          min_width = 60,
          max_height = math.floor(vim.o.lines * 0.3),
          min_height = 1,
        },
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
      nnoremap {
        "<A-m>",
        [[<cmd>NvimTreeToggle<CR>]],
        { silent = true },
      }
      vim.g.nvim_tree_indent_markers = 1
      vim.g.nvim_tree_highlight_opened_files = 1
      -- vim.g.nvim_tree_git_hl = 1
    end,
  }
end)

-- INFO deferred loading for `speedup`
vim.defer_fn(function()
  vim.cmd [[
  PackerLoad nvim-treesitter
  PackerLoad galaxyline.nvim
  PackerLoad indent-blankline.nvim
  PackerLoad gitsigns.nvim
  PackerLoad plenary.nvim
  PackerLoad popup.nvim
  PackerLoad telescope-fzf-native.nvim
  PackerLoad telescope-hop.nvim
  PackerLoad telescope.nvim
  PackerLoad vim-slime
  PackerLoad telescope-dap.nvim
  PackerLoad nvim-dap
  PackerLoad vim-cool
  PackerLoad hop.nvim
  PackerLoad markdown-preview.nvim
  PackerLoad octo.nvim
  silent! bufdo e
  ]]
end, 0)
