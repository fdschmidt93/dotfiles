local use = require('packer').use

require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  use {
    'morhetz/gruvbox',
    config = function()
      vim.cmd [[colorscheme gruvbox]]
      vim.g.background = 'dark'
      -- set highlight groups right after colorscheme to avoid clear
      require 'highlights'
    end
  }
  -- Post-install/update hook with neovim command
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require 'treesitter' end,
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-refactor',
      'romgrk/nvim-treesitter-context'
    }
  }
  use 'tjdevries/astronauta.nvim'
  use 'romainl/vim-cool' -- disable search highlight when done
  use 'tpope/vim-commentary' -- gc mapping to comment stuff out
  use 'tpope/vim-fugitive' -- git integration for vim
  use {'chrisbra/csv.vim', ft = 'csv'}
  use {
    'glepnir/indent-guides.nvim',
    ft = {'lua', 'python'},
    config = function()
      local colors = require 'colors.gruvbox'
      require'indent_guides'.setup {
        even_colors = {fg = colors.dark1, bg = colors.dark0},
        odd_colors = {fg = colors.dark0, bg = colors.dark1}
      }
    end
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
  use 'tpope/vim-surround' -- quoting/parenthesizing made simple
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require 'statusline' end,
    after = 'nvim-treesitter',
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  use {
    'akinsho/nvim-bufferline.lua',
    after = {'gruvbox'},
    requires = {'kyazdani42/nvim-web-devicons'},
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
    config = function() require'colorizer'.setup() end
  } -- show hex rgb colors
  use 'TimUntersberger/neogit'
  use {
    'kkoomen/vim-doge',
    run = function() vim.fn['doge#install()'](0) end,
    config = function() vim.g.doge_enable_mappings = 1 end
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim'},
    config = function() require 'scope' end,
    after = {'telescope-fzy-native.nvim', 'astronauta.nvim'}
  }
  use {
    'neovim/nvim-lspconfig',
    after = {'lspsaga.nvim', 'telescope.nvim', 'astronauta.nvim'},
    requires = {'glepnir/lspsaga.nvim'},
    config = function() require 'lsp_config' end
  }
  use {
    'hrsh7th/nvim-compe',
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
    after = {'gruvbox'},
    config = function() vim.cmd [[let g:vimwiki_global_ext = 1]] end
  }
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function() require('gitsigns').setup() end
  }
end)
