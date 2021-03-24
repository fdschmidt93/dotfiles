local use = require'packer'.use
local prog_ft = {'lua', 'python'}

require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim'}

  -- floating window preview for quickfix list
  use 'kevinhwang91/nvim-bqf'
  -- disable search highlight when done
  use 'romainl/vim-cool'
  use {
    'lukas-reineke/indent-blankline.nvim',
    -- TODO check why it cannot be linked to programming filetypes
    config = function() vim.g.indent_blankline_filetype = {'python', 'lua'} end,
    branch = "lua"
  }

  use 'tjdevries/astronauta.nvim'
  -- gc mapping to comment stuff out
  use 'tpope/vim-commentary'
  -- quoting/parenthesizing made simple
  use 'tpope/vim-surround'
  use {'chrisbra/csv.vim', ft = 'csv'}
  -- git integration for vim
  use {'tpope/vim-fugitive', cmd = 'Git'}
  use {'morhetz/gruvbox', config = function() require 'highlights' end}
  use 'kyazdani42/nvim-web-devicons'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      -- 'romgrk/nvim-treesitter-context'
    },
    config = function() require 'treesitter' end
  }
  use {
    'justinmk/vim-sneak',
    config = function()
      vim.cmd [[let g:sneak#label = 1]]
      vim.api.nvim_set_keymap('', 'f', '<Plug>Sneak_f', {})
      vim.api.nvim_set_keymap('', 'F', '<Plug>Sneak_F', {})
      vim.api.nvim_set_keymap('', 't', '<Plug>Sneak_t', {})
      vim.api.nvim_set_keymap('', 'T', '<Plug>Sneak_T', {})
    end
  }
  use {
    'phaazon/hop.nvim',
    after = {'gruvbox', 'vim-sneak'},
    config = function()
      local k = require 'astronauta.keymap'

      local nnoremap = k.nnoremap
      local vnoremap = k.vnoremap

      for _, map in pairs({nnoremap, vnoremap}) do
        map {'<C-s>', require'hop'.hint_char2}
        map {'<C-f>', require'hop'.hint_char1}
        map {'<C-l>', require'hop'.hint_lines}
      end

      -- hl groups
      local colors = require 'colors.gruvbox'
      local utils = require 'utils'
      local highlights = {
        {'HopNextKey', {fg = colors.bright_orange, gui = 'bold,underline'}},
        {'HopNextKey1', {fg = colors.bright_green, gui = 'bold,underline'}},
        {'HopNextKey2', {fg = colors.neutral_green}},
        {'HopUnmatched', {fg = colors.light4}}
      }
      for _, hl in pairs(highlights) do utils.set_hl(hl[1], hl[2]) end
    end
  }
  use {
    'mfussenegger/nvim-dap',
    after = 'gruvbox',
    ft = prog_ft,
    config = function()
      local nnoremap = require'astronauta.keymap'.nnoremap
      local opts = {silent = true}
      nnoremap {'<F5>', require'dap'.continue, opts}
      nnoremap {'<F10>', require'dap'.step_over, opts}
      nnoremap {'<F11>', require'dap'.step_into, opts}
      nnoremap {'<F12>', require'dap'.step_out, opts}
      nnoremap {'<space>b', require'dap'.toggle_breakpoint, opts}
      nnoremap {'<space>dr', require'dap'.repl.open, opts}
      nnoremap {'<space>dl', require'dap'.run_last, opts}
    end
  }
  use {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    after = 'nvim-dap',
    config = function()
      local python_path = string.format('/home/%s/miniconda3/bin/python',
                                        os.getenv('USER'))
      require('dap-python').setup(python_path)
    end
  }
  use {
    'nvim-telescope/telescope-dap.nvim',
    requires = 'nvim-dap',
    config = function() 
      require('telescope').load_extension('dap')
      vim.fn.sign_define('DapBreakpoint', {text = '', texthl = 'Breakpoint'})
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'Stopped'})
    end,
    ft = prog_ft
  }
  -- REPL for vim
  use {
    'jpalardy/vim-slime',
    config = function()
      vim.g.slime_target = 'neovim'
      vim.g.slime_python_ipython = 1
    end
  }
  -- enable repeating supported plugin maps with dot
  use {
    'tpope/vim-repeat',
    config = function()
      vim.cmd [[silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)]]
    end
  }
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require 'statusline' end,
    after = 'nvim-treesitter'
  }
  use {
    'akinsho/nvim-bufferline.lua',
    after = 'gruvbox',
    config = function()
      require'bufferline'.setup {
        options = {
          view = 'multiwindow',
          numbers = 'ordinal',
          number_style = 'superscript',
          mappings = true,
          tab_size = 18,
          show_buffer_close_icons = false,
          separator_style = 'thin',
          enforce_regular_tabs = true
        }
      }
    end
  }
  use {
    'antoinemadec/FixCursorHold.nvim',
    config = function() vim.g.cursorhold_updatetime = 500 end
  }
  use {
    'norcalli/nvim-colorizer.lua',
    after = 'gruvbox',
    ft = 'lua',
    config = function() require'colorizer'.setup() end
  } -- show hex rgb colors
  use {'TimUntersberger/neogit', cmd = 'Neogit'}
  use {
    'kkoomen/vim-doge',
    ft = prog_ft,
    run = ':call doge#install()',
    config = function() vim.g.doge_enable_mappings = 1 end
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      'tjdevries/astronauta.nvim', 'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim', 'nvim-telescope/telescope-fzy-native.nvim'
    },
    config = function() require 'scope' end
  }
  use {
    'neovim/nvim-lspconfig',
    after = 'gruvbox',
    ft = prog_ft,
    requires = {'glepnir/lspsaga.nvim', 'nvim-telescope/telescope.nvim'},
    config = function() require 'lsp_config' end
  }
  use {
    'hrsh7th/nvim-compe',
    -- load compe only after entering insert mode
    event = 'InsertEnter',
    config = function()
      vim.o.completeopt = 'menuone,noselect'
      require'compe'.setup {
        enabled = true,
        autocomplete = true,
        debug = false,
        min_length = 1,
        preselect = 'disable',
        throttle_time = 0,
        source_timeout = 200,
        incomplete_delay = 400,
        allow_prefix_unmatch = false,
        source = {
          path = true,
          buffer = true,
          vsnip = false,
          nvim_lsp = true,
          treesitter = true
        }
      }
    end
  }
  use {
    'lervag/vimtex',
    ft = 'tex',
    config = function()
      vim.g.tex_flavor = 'latex'
      vim.g.vimtex_fold_manual = 1
      vim.g.vimtex_latexmk_continuous = 1
      vim.g.vimtex_compiler_progname = 'nvr'
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_quickfix_mode = 0
      vim.wo.conceallevel = 2
      vim.g.tex_conceal = 'abdgm'
    end
  }
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = 'markdown',
    cmd = 'MarkdownPreview'
  }
  use {
    'vimwiki/vimwiki',
    ft = 'markdown',
    config = function() vim.cmd [[let g:vimwiki_global_ext = 1]] end
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function() require('gitsigns').setup() end
  }
end)
