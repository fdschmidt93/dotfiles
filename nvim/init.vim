" [0] Plugins{{{
call plug#begin('~/dotfiles/nvim/plugged')
" Extend Vim 
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
" Coding
Plug 'jpalardy/vim-slime'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kkoomen/vim-doge'
" Python
Plug 'vim-python/python-syntax'
Plug 'vimwiki/vimwiki'
" Themes
Plug 'crusoexia/vim-monokai'
Plug 'gruvbox-community/gruvbox'
Plug 'iCyMind/NeoSolarized'
Plug 'arcticicestudio/nord-vim'
" Convenience
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'haya14busa/incsearch.vim'
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
call plug#end()"}}}

" [1] General{{{
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab		" indentation for yaml files
filetype plugin indent on                                       " tab to space
filetype plugin on
let g:incsearch#auto_nohlsearch = 1                             " Search config: no highlighting
set expandtab                                                   " On pressing tab, insert 4 spaces
set foldmethod=marker 						                    " Enable folding (1)
set foldlevel=99 							                    " Enable folding (2)
set ignorecase 								                    " Search config: ignore case
set incsearch 								                    " Search config: incremental search
set nocompatible
set number relativenumber 			                            " Numbering
set shiftwidth=4                                                " when indenting with '>', use 4 spaces width
set smartcase 								                    " Search config: smart case
set splitright 								                    " Set split window right
set tabstop=4                                                   " show existing tab with 4 spaces width
syntax on"}}}

" [2] Theme & Syntax Highlighting{{{
set termguicolors 							" Enable full colorscheme
let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_colors = { 'bg0': ['#251a10', 0] }
set background=dark
colorscheme gruvbox
syntax enable 								" Syntax highlighting
let g:python_highlight_all = 1 						" Python syntax highlighting}}}

" [3] Keymappings{{{
nnoremap <space> za|	     	 	                " Enable folding with the spacebar
imap jk <Esc>|								        " Go to normal mode with jk
nmap oo m`o<Esc>``|							        " Insert empty line below with oo
nmap OO m`O<Esc>``|							        " Insert empty line above with OO
nmap <Leader>y "+y|							        " Copy to global clipboard with leader prefix
nmap <Leader>p "+p|							        " Paste from global clipboard with leader prefix
nmap <Leader>t :vs+te<CR>|					    	" Open right-sided terminal with <leader>t
nmap <Leader><C-t> :new+te<CR>:resize 15<CR><C-w>r| " Open right-sided terminal with <leader>t
nmap <Leader>w :w<CR>|							    " Save buffer with <leader>w
nmap <Leader>q :q!<CR>|							    " Close buffer with <leader>q
tnoremap <A-h> <C-\><C-N><C-w>h|					" Move with M from any mode
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
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)"}}}

" [4.1] vim-repeat{{{
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)}}}

" [4.2] vim-slime{{{
let g:slime_target = "neovim"
let g:slime_python_ipython = 1"}}}

" [4.3] fzf{{{
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>rg :Rg<cr>"}}}

" [4.4] vimtex{{{
let g:tex_flavor  = 'latex'
let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'"}}}

" [4.5] vim-airline{{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:airline_powerline_fonts = 1"}}}

" [4.6] vim-doge{{{
let g:doge_enable_mappings = 1 "}}}

" [4.7] coc.nvim{{{
let g:coc_global_extensions = ['coc-json', 'coc-vimtex', 'coc-snippets', 'coc-python']

set updatetime=300

inoremap <silent><expr> <c-space> coc#refresh()|			        " Use <c-space> for trigger completion.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"|		" <cr> to confirm

nmap <silent> [c <Plug>(coc-diagnostic-prev)|				        " Use `[c` and `]c` for navigate diagnostics
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)|				            " Remap keys for gotos
nmap <silent> gD <Plug>(coc-declaration)|				            " Remap keys for gotos
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)|					                " Remap for rename current word

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>|		    " K to show docs in preview window
autocmd CursorHold * silent call CocActionAsync('highlight')        " Highlight symbol under cursor on CursorHold

augroup mygroup autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

vmap <leader>cf  <Plug>(coc-format-selected)|				        " Remap for format selected region
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
imap <C-j> <Plug>(coc-snippets-expand-jump)"}}}
