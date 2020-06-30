"# [0] vim-plug
call plug#begin('~/dotfiles/nvim/plugged')
" Extend Vim 
Plug 'romainl/vim-cool'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" Coding
Plug 'jpalardy/vim-slime'
Plug 'kkoomen/vim-doge'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Python
Plug 'vim-python/python-syntax'
" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'crusoexia/vim-monokai'
Plug 'morhetz/gruvbox'
Plug 'iCyMind/NeoSolarized'
" fzf
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
" Other
Plug 'lervag/vimtex'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'hardcoreplayers/oceanic-material'
call plug#end()

"# [1] General
filetype plugin indent on
" On pressing tab, insert spaces
set expandtab
" Number of spaces that a <Tab> in the file counts for
set tabstop=4
" Search config
set ignorecase
set smartcase
" (Relative) Line Numbering
set number relativenumber
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" Set split window right
set splitright
" Fold by syntax
set foldmethod=syntax
set modelineexpr

"# [2] Theme & Syntax Highlighting
" Theme
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
" Syntax highlighting
syntax on
syntax enable
" Python syntax highlighting
let g:python_highlight_all = 1

"# [3] Mappings
" Go to normal mode with jk
imap jk <Esc>|
" Insert empty line below with oo
nmap oo m`o<Esc>``|
" Insert empty line above with OO
nmap OO m`O<Esc>``|
" Copy to global clipboard with leader prefix
nmap <Leader>y "+y|
" Paste from global clipboard with leader prefix
nmap <Leader>p "+p|
" Open right-sided terminal with <leader>t
nmap <Leader>t :vs+te<CR>|
" Open (smaller) terminal below
nmap <Leader><C-t> :new+te<CR>:resize 15<CR><C-w>r|
" Save buffer with <leader>w
nmap <Leader>w :w<CR>|
" Close buffer with <leader>q
nmap <Leader>q :q!<CR>|
" Move with M from any mode
tnoremap <A-h> <C-\><C-N><C-w>h|
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

"# [4] Plugins

"# [4.1] vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

"# [4.2] vim-slime
let g:slime_target = "neovim"
let g:slime_python_ipython = 1"

"# [4.3] fzf
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>rg :Rg<cr>
nnoremap <Leader>co :Colors<cr>

"# [4.4] vimtex
let g:tex_flavor  = 'latex'
let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'"

"# [4.5] vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:airline_powerline_fonts = 1"

"# [4.6] vim-doge
let g:doge_enable_mappings = 1 "

"# [4.7] coc.nvim
let g:coc_global_extensions = ['coc-json', 'coc-vimtex', 'coc-snippets', 'coc-python']

set updatetime=300

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()|
" <cr> to confirm
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"|

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)|
nmap <silent> ]c <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)|
nmap <silent> gD <Plug>(coc-declaration)|
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)|

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" K to show docs in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>|
" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

augroup mygroup autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for format selected region
vmap <leader>cf  <Plug>(coc-format-selected)|
nmap <leader>cf  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>" Show all diagnostics
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" coc-snippets
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)"

" vim:fdm=expr:fdl=0
" vim:fde=getline(v\:lnum)=~'^"#'?'>'.(matchend(getline(v\:lnum),'"#*')-1)\:'='
