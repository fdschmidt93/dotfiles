local use = require('packer').use
require('packer').startup(function()
  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- Simple plugins can be specified as strings
  use {
    'morhetz/gruvbox',
    -- 'npxbr/gruvbox.nvim',
    -- requires = {"rktjmp/lush.nvim"},
    config = function()
      vim.cmd [[colorscheme gruvbox]]
      vim.g.background = 'dark'
      -- set highlight groups right after colorscheme to avoid clear
      require 'highlights'
    end
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
      require'indent_guides'.setup {indent_tab_guides = true}
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
      vim.g.slime_target = "neovim"
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
    'akinsho/nvim-bufferline.lua',
    after = 'gruvbox',
    config = function()
      require'bufferline'.setup {
        options = {
          view = "multiwindow",
          numbers = "ordinal",
          number_style = "superscript",
          mappings = true,
          tab_size = 18,
          show_buffer_close_icons = false,
          separator_style = "thin",
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
  use {
    'kyazdani42/nvim-web-devicons', -- Recommended (for coloured icons)
    config = function() require('nvim-web-devicons').setup {default = true} end
  }
  use {'TimUntersberger/neogit'}
  use {
    'kkoomen/vim-doge',
    run = function() vim.fn['doge#install()'](0) end,
    config = function() vim.g.doge_enable_mappings = 1 end
  }

  use 'glepnir/lspsaga.nvim'
  use {'neovim/nvim-lspconfig', config = function() require 'lsp_config' end}
  use {
    'hrsh7th/nvim-compe',
    config = function()
      vim.o.completeopt = "menuone,noselect"
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
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
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
      vim.g.tex_conceal = "abdgm"
    end
  }
  use {
    'lukas-reineke/format.nvim',
    ft = 'python',
    config = function()
      require("format").setup {
        python = {{cmd = {"black", "isort"}}},
        lua = {
          {
            cmd = {
              function(file)
                return string.format("luafmt -l %s -w replace %s",
                                     vim.bo.textwidth, file)
              end
            }
          }
        }
      }
    end
  }

  -- Plugins can have post-install/update hooks
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install',
    ft = 'markdown',
    cmd = 'MarkdownPreview'
  }
  use {
    'vimwiki/vimwiki',
    ft = 'markdown',
    config = function()
      vim.api.nvim_exec([[
        hi link VimwikiHeader1 gruvbox_bright_green_bold
        hi link VimwikiHeader2 gruvbox_bright_aqua_bold
        hi link VimwikiHeader3 gruvbox_bright_yellow_bold
        hi link VimwikiHeader4 gruvbox_bright_orange_bold
        hi link VimwikiHeader5 gruvbox_bright_red_bold
        hi link VimwikiHeader6 gruvbox_bright_purple_bold]])
    end
  }

  use {
    '~/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim', 'nvim-lua/popup.nvim'},
    config = function() require 'scope' end
  }
  use 'nvim-telescope/telescope-fzy-native.nvim'
  --
  -- Post-install/update hook with neovim command
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require 'treesitter' end
  }
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- fast incremental syntax highlighting and more
  use 'nvim-treesitter/nvim-treesitter-refactor'
  use 'romgrk/nvim-treesitter-context'

  -- Use specific branch, dependency and run lua file after load
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    config = function() require 'statusline' end,
    requires = {'kyazdani42/nvim-web-devicons'}
  }

  -- Use dependency and run lua function after load
  use {
    'lewis6991/gitsigns.nvim',
    requires = {'nvim-lua/plenary.nvim'},
    config = function() require('gitsigns').setup() end
  }
end)
