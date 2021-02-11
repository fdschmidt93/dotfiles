"# [0] vim-plug
call plug#begin('~/.config/nvim/plugged')
" Extend Vim
" Extend
" Vim
Plug 'romainl/vim-cool' " disable search highlight when done
Plug 'tpope/vim-commentary' " gc mapping to comment stuff out
" Plug 'b3nj5m1n/kommentary'
Plug 'tpope/vim-fugitive' " git integration for vim
Plug 'tpope/vim-repeat' " enable repeating supported plugin maps with dot
Plug 'tpope/vim-surround' " quoting/parenthesizing made simple
Plug 'tpope/vim-unimpaired' " 
Plug 'justinmk/vim-sneak' " 2 character motions Coding
Plug 'jpalardy/vim-slime' " REPL for vim
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }

" Python
Plug 'nvim-treesitter/nvim-treesitter' " fast incremental syntax highlighting and more
Plug 'nvim-treesitter/nvim-treesitter-textobjects' " fast incremental syntax highlighting and more
Plug 'romgrk/nvim-treesitter-context'
Plug 'nvim-treesitter/nvim-treesitter-refactor'

" Themes
Plug 'morhetz/gruvbox' " main theme
" Other
Plug 'vimwiki/vimwiki'
Plug 'norcalli/nvim-colorizer.lua' " show hex rgb colors
Plug 'chrisbra/csv.vim'
Plug 'itchyny/calendar.vim'
Plug 'mattn/emmet-vim'
" Writing
Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'} " prettify latex syntax
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  } " live markdown
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'Akin909/nvim-bufferline.lua' " beautiful tabline

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'lukas-reineke/format.nvim'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'nvim-lua/lsp-status.nvim'
Plug 'antoinemadec/FixCursorHold.nvim'
" Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'kyazdani42/nvim-tree.lua'
" Plug 'rafcamlet/nvim-luapad'
Plug 'bfredl/nvim-luadev'
Plug 'akinsho/nvim-toggleterm.lua'
 Plug 'TimUntersberger/neogit'
call plug#end()
" see lua for lua configs
:lua << EOF
require('status_line').load_galaxyline() -- load galaxyline nvim
require('treesitter')
require('scope')
require('lsp_config')
require('term')
repl = require('repl') -- shortcuts for vim-slime
EOF

"# [1] General
filetype plugin indent on
set expandtab " On pressing tab, insert spaces
set tabstop=4 " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4 " when indenting with '>', use 4 spaces width
set ignorecase " Search config
set smartcase
set incsearch
set number relativenumber " (Relative) Line Numbering
set splitbelow " New horizontal splits window below
set splitright " New vertical splits window right
set foldmethod=syntax " Fold by syntax
set modelineexpr
set inccommand=nosplit " Preview substitution
set guifont=Fira\ Code\ Nerd\ Font:h16 " Neovide font
set clipboard^=unnamed,unnamedplus " clipboard
set noshowmode " mode show by airline
set hidden
set scrolloff=10  "always 10 lines below/above cursor 
let g:cursorhold_updatetime = 500

"# [2] Theme & Syntax Highlighting
" Theme
set cursorline " highlight current line
set termguicolors
set background=dark
" let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
" let g:gruvbox_material_palette = 'mix'
" let g:gruvbox_material_enable_bold = 1
" let g:gruvbox_material_enable_italic = 1
" colorscheme gruvbox-material

syntax enable
let &fcs='eob: ' " hide end of buffer line markers
" highlight VertSplit ctermbg=NONE guibg=NONE guifg=NONE ctermfg=NONE 
highlight VertSplit ctermbg=NONE guibg=NONE guifg=#3c3836 ctermfg=NONE " hide background of VertSplit
set guifont=Fira\ Code\ Nerd\ Font:h14 " neovide font setting
highlight Comment gui=italic
if exists('g:neovide') " use opacity for alacritty
else
    highlight Normal ctermbg=NONE guibg=NONE
endif
set fillchars+=vert:\|
" set fillchars=vert:│
augroup LuaHighlight " highlight yanking with Gruvbox Aqua
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({higroup="gruvbox_yank", timeout=250})
augroup END
set fillchars+=vert:\▏
hi Pmenu ctermbg=NONE guibg=#3c3836 " merge with cursorline style
:lua require('colorizer').setup() -- rgb hex color codes in nvim
"
" beautiful tabline
:lua << EOF
require'bufferline'.setup{
    options = {
        view = "multiwindow",
        numbers = "ordinal",
        number_style = "superscript",
        mappings = true,
        -- close_icon = "",
        -- max_name_length = 18,
        tab_size = 18,
        show_buffer_close_icons = false,
        separator_style = "thin",
        enforce_regular_tabs = true
    },
}
EOF
"# [3] Mappings
imap jk <Esc>| " Go to normal mode with jk
nmap oo m`o<Esc>``| " Insert empty line below with oo
nmap OO m`O<Esc>``| " Insert empty line above with OO
nmap <Leader>y "+y| " Copy to global clipboard with leader prefix
nmap <Leader>p "+p| " Paste from global clipboard with leader prefix
nnoremap Y y$ " consistent capitalized letter
" resize splits with arrow keys
noremap <silent> <C-S-Left> :vertical resize +2<CR> " Resize splits with arrow keys
noremap <silent> <C-S-Right> :vertical resize -2<CR>
noremap <silent> <C-S-Up> :resize +2<CR>
noremap <silent> <C-S-Down> :resize -2<CR>
" enhance vim-slime with lua
nmap <Leader>t :lua repl.shell("right", nil)<CR>" Open right-sided terminal with <leader>t
nmap <Leader>ti :lua repl.shell("right", "ipython") <CR>" Open right-sided terminal with <leader>t
nmap <Leader><C-t> :lua repl.shell("below", nil)<CR> " Open (smaller) terminal below
nmap <Leader><C-t>i :lua repl.shell("below", "ipython")<CR> " Open (smaller) terminal below
nmap <Leader>w :FormatWrite!<CR>| " Save buffer with <leader>w
nmap <Leader>q :q!<CR>| " Close buffer with <leader>q
" move around splits with alt
tnoremap <A-h> <C-\><C-N><C-w>h| " Move with M from any mode
tnoremap <A-j> <C-\><C-N><C-w>j|
tnoremap <A-k> <C-\><C-N><C-w>k|
tnoremap <A-l> <C-\><C-N><C-w>l|
inoremap <A-h> <C-\><C-N><C-w>h|
inoremap <A-j> <C-\><C-N><C-w>j|
inoremap <A-k> <C-\><C-N><C-w>k|
inoremap <A-l> <C-\><C-N><C-w>l|
nnoremap <A-h> <C-w>h|
nnoremap <A-j> <C-w>j|
nnoremap <A-k> <C-w>k|	
nnoremap <A-l> <C-w>l|
" vim.sneak
let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" tree lua
nnoremap <Leader>nt :LuaTreeToggle<CR>
nnoremap <Leader>nf :LuaTreeFindFile<cr>:LuaTreeShow<CR>
" html for neomutt
nnoremap <Leader>ht :set filetype=html<CR>
" nnoremap <space>co :CHADopen<CR>

"
"# [4] Plugins

"# [4.1] vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

"# [4.2] vim-slime
let g:slime_target = "neovim"
let g:slime_python_ipython = 1
" let g:slime_dont_ask_default = 1

"# [4.3] telescope
highlight! link TelescopeBorder         gruvbox_neutral_aqua
highlight! link TelescopePromptBorder   gruvbox_bright_blue
highlight! link TelescopeResultsBorder  gruvbox_neutral_aqua
highlight! link TelescopePreviewBorder  gruvbox_neutral_aqua



"# [4.4] latex 
" vimtex
let g:tex_flavor  = 'latex'
let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode=0
" inkscape
autocmd FileType tex inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
autocmd FileType tex nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
autocmd FileType tex nnoremap <buffer> <localleader>lt :call vimtex#fzf#run('clti', g:fzf_layout)<cr>
autocmd FileType tex nnoremap <buffer> <localleader><localleader>lc :call vimtex#fzf#run('c', g:fzf_layout)<cr>
autocmd FileType tex nnoremap <buffer> <localleader><localleader>lt :call vimtex#fzf#run('t', g:fzf_layout)<cr>
autocmd FileType tex nnoremap <buffer> <localleader><localleader>ll :call vimtex#fzf#run('l', g:fzf_layout)<cr>
" tex conceal
set conceallevel=2
let g:tex_conceal="abdgm"


"# [4.4] vim-doge
let g:doge_enable_mappings = 1 "


"# [4.5] vimwiki / calendar.vim
" let g:vimwiki_list = [{'path': '~/vimwiki/',  'syntax': 'markdown', 'ext': '.md'}]

  " let g:vimwiki_ext2syntax = {'': 'markdown'}
" let g:vimwiki_filetypes = ['markdown', 'pandoc']
hi link VimwikiHeader1 gruvbox_bright_green_bold
hi link VimwikiHeader2 gruvbox_bright_aqua_bold
hi link VimwikiHeader3 gruvbox_bright_yellow_bold
hi link VimwikiHeader4 gruvbox_bright_orange_bold
hi link VimwikiHeader5 gruvbox_bright_red_bold
hi link VimwikiHeader6 gruvbox_bright_purple_bold
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_global_ext = 1
let g:calendar_google_calendar = 1

"# [4.6] gruvbox colors

" fg'
hi gruvbox_dark0_hard  guifg=#1d2021
hi gruvbox_dark0       guifg=#282828
hi gruvbox_dark0_soft  guifg=#32302f
hi gruvbox_dark1       guifg=#3c3836
hi gruvbox_dark2       guifg=#504945
hi gruvbox_dark3       guifg=#665c54
hi gruvbox_dark4       guifg=#7c6f64
hi gruvbox_dark4_256   guifg=#7c6f64
hi gruvbox_gray_245    guifg=#928374
hi gruvbox_gray_244    guifg=#928374
hi gruvbox_light0_hard guifg=#f9f5d7
hi gruvbox_light0      guifg=#fbf1c7
hi gruvbox_light0_soft guifg=#f2e5bc
hi gruvbox_light1      guifg=#ebdbb2
hi gruvbox_light2      guifg=#d5c4a1
hi gruvbox_light3      guifg=#bdae93
hi gruvbox_light4      guifg=#a89984
hi gruvbox_light4_256  guifg=#a89984
hi gruvbox_bright_red     guifg=#fb4934
hi gruvbox_bright_green   guifg=#b8bb26
hi gruvbox_bright_yellow  guifg=#fabd2f
hi gruvbox_bright_blue    guifg=#83a598
hi gruvbox_bright_purple  guifg=#d3869b
hi gruvbox_bright_aqua    guifg=#8ec07c
hi gruvbox_bright_orange  guifg=#fe8019
hi gruvbox_neutral_red    guifg=#cc241d
hi gruvbox_neutral_green  guifg=#98971a
hi gruvbox_neutral_yellow guifg=#d79921
hi gruvbox_neutral_blue   guifg=#458588
hi gruvbox_neutral_purple guifg=#b16286
hi gruvbox_neutral_aqua   guifg=#689d6a
hi gruvbox_neutral_orange guifg=#d65d0e
hi gruvbox_faded_red      guifg=#9d0006
hi gruvbox_faded_green    guifg=#79740e
hi gruvbox_faded_yellow   guifg=#b57614
hi gruvbox_faded_blue     guifg=#076678
hi gruvbox_faded_purple   guifg=#8f3f71
hi gruvbox_faded_aqua     guifg=#427b58
hi gruvbox_faded_orange   guifg=#af3a03

" fg-bold
hi gruvbox_bright_red_bold     gui=bold guifg=#fb4934 
hi gruvbox_bright_green_bold   gui=bold guifg=#b8bb26 
hi gruvbox_bright_yellow_bold  gui=bold guifg=#fabd2f 
hi gruvbox_bright_blue_bold    gui=bold guifg=#83a598 
hi gruvbox_bright_purple_bold  gui=bold guifg=#d3869b 
hi gruvbox_bright_aqua_bold    gui=bold guifg=#8ec07c 
hi gruvbox_bright_orange_bold  gui=bold guifg=#fe8019 
hi gruvbox_neutral_red_bold    gui=bold guifg=#cc241d 
hi gruvbox_neutral_green_bold  gui=bold guifg=#98971a 
hi gruvbox_neutral_yellow_bold gui=bold guifg=#d79921 
hi gruvbox_neutral_blue_bold   gui=bold guifg=#458588 
hi gruvbox_neutral_purple_bold gui=bold guifg=#b16286 
hi gruvbox_neutral_aqua_bold   gui=bold guifg=#689d6a 
hi gruvbox_neutral_orange_bold gui=bold guifg=#d65d0e 
hi gruvbox_faded_red_bold      gui=bold guifg=#9d0006 
hi gruvbox_faded_green_bold    gui=bold guifg=#79740e 
hi gruvbox_faded_yellow_bold   gui=bold guifg=#b57614 
hi gruvbox_faded_blue_bold     gui=bold guifg=#076678 
hi gruvbox_faded_purple_bold   gui=bold guifg=#8f3f71 
hi gruvbox_faded_aqua_bold     gui=bold guifg=#427b58 
hi gruvbox_faded_orange_bold   gui=bold guifg=#af3a03 

" bg
hi gruvbox_dark0_hard_bg  guibg=#1d2021
hi gruvbox_dark0_bg       guibg=#282828
hi gruvbox_dark0_soft_bg  guibg=#32302f
hi gruvbox_dark1_bg       guibg=#3c3836
hi gruvbox_dark2_bg       guibg=#504945
hi gruvbox_dark3_bg       guibg=#665c54
hi gruvbox_dark4_bg       guibg=#7c6f64
hi gruvbox_dark4_256_bg   guibg=#7c6f64
hi gruvbox_gray_245_bg    guibg=#928374
hi gruvbox_gray_244_bg    guibg=#928374
hi gruvbox_light0_hard_bg guibg=#f9f5d7
hi gruvbox_light0_bg      guibg=#fbf1c7
hi gruvbox_light0_soft_bg guibg=#f2e5bc
hi gruvbox_light1_bg      guibg=#ebdbb2
hi gruvbox_light2_bg      guibg=#d5c4a1
hi gruvbox_light3_bg      guibg=#bdae93
hi gruvbox_light4_bg      guibg=#a89984
hi gruvbox_light4_256_bg  guibg=#a89984
hi gruvbox_bright_red_bg     guibg=#fb4934
hi gruvbox_bright_green_bg   guibg=#b8bb26
hi gruvbox_bright_yellow_bg  guibg=#fabd2f
hi gruvbox_bright_blue_bg    guibg=#83a598
hi gruvbox_bright_purple_bg  guibg=#d3869b
hi gruvbox_bright_aqua_bg    guibg=#8ec07c
hi gruvbox_bright_orange_bg  guibg=#fe8019
hi gruvbox_neutral_red_bg    guibg=#cc241d
hi gruvbox_neutral_green_bg  guibg=#98971a
hi gruvbox_neutral_yellow_bg guibg=#d79921
hi gruvbox_neutral_blue_bg   guibg=#458588
hi gruvbox_neutral_purple_bg guibg=#b16286
hi gruvbox_neutral_aqua_bg   guibg=#689d6a
hi gruvbox_neutral_orange_bg guibg=#d65d0e
hi gruvbox_faded_red_bg      guibg=#9d0006
hi gruvbox_faded_green_bg    guibg=#79740e
hi gruvbox_faded_yellow_bg   guibg=#b57614
hi gruvbox_faded_blue_bg     guibg=#076678
hi gruvbox_faded_purple_bg   guibg=#8f3f71
hi gruvbox_faded_aqua_bg     guibg=#427b58
hi gruvbox_faded_orange_bg   guibg=#af3a03

hi gruvbox_yank guibg=#8ec07c guifg=#f9f5d7


"# [4.10] LSP

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

"# [4.11] format.nvim
:lua << EOF
require("format").setup{
    python = {
        {cmd = {"black", "isort"}}
    },
    lua = {
        {
            cmd = {
                function(file)
                    return string.format("luafmt -l %s -w replace %s", vim.bo.textwidth, file)
                end
            }
        }
    },
}
EOF

"# [4.12] devicons
" must be loaded last
:lua << EOF
require('nvim-web-devicons').setup{default=true}
require'nvim-web-devicons'.setup {
 default = true;
}
EOF
" augroup Format
"     autocmd!
"     autocmd BufWritePost * FormatWrite
" augroup END

" vim:fdm=expr:fdl=0
" vim:fde=getline(v\:lnum)=~'^"#'?'>'.(matchend(getline(v\:lnum),'"#*')-1)\:'='
