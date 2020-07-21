"# [0] vim-plug
call plug#begin('~/.config/nvim/plugged')
" Extend Vim 
Plug 'romainl/vim-cool'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'justinmk/vim-sneak'
Plug 'easymotion/vim-easymotion'
" Coding
Plug 'jpalardy/vim-slime'
Plug 'kkoomen/vim-doge'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Python
Plug 'nvim-treesitter/nvim-treesitter'"
" Themes
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
Plug 'crusoexia/vim-monokai'
Plug 'iCyMind/NeoSolarized'
" fzf
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
" Other
Plug 'lervag/vimtex'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'chrisbra/csv.vim'
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
" Preview substitution
set inccommand=nosplit
" Neovide font
set guifont="Fira Code": 10
" colorizer

"# [2] Theme & Syntax Highlighting
" Theme
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
syntax on
syntax enable
lua require'colorizer'.setup()
" neovide font setting
set guifont=Fira\ Code\ Nerd\ Font:h14
" use opacity of alacritty
"highlight Normal ctermbg=NONE guibg=NONE
" hide end of buffer line markers
let &fcs='eob: '

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
" vim.sneak
let g:sneak#label = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
" vim.easymotion
map  gs <Plug>(easymotion-bd-f)
map  gS <Plug>(easymotion-bd-w)


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
inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>


"# [4.5] vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#coc#enabled = 1
let g:airline_powerline_fonts = 1"

"# [4.6] vim-doge
let g:doge_enable_mappings = 1 "

"# [4.7] coc.nvim
let g:coc_global_extensions = ['coc-json', 'coc-vimtex', 'coc-snippets', 'coc-python', 'coc-pyright']

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

"
"# [4.8] nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,                    -- false will disable the whole extension
        disable = {},                     -- list of language that will be disabled
        custom_captures = {               -- mapping of user defined captures to highlight groups
          -- ["foo.bar"] = "Identifier"   -- highlight own capture @foo.bar with highlight group "Identifier", see :h nvim-treesitter-query-extensions
        },            
    },
    incremental_selection = {
        enable = true,
        disable = {},
        keymaps = {                       -- mappings for incremental selection (visual mappings)
          init_selection = 'gnn',         -- maps in normal mode to init the node/scope selection
          node_incremental = "grn",       -- increment to the upper named parent
          scope_incremental = "grc",      -- increment to the upper scope (as defined in locals.scm)
          node_decremental = "grm",       -- decrement to the previous node
        }
    },
    refactor = {
      highlight_definitions = {
        enable = true
      },
      highlight_current_scope = {
        enable = false
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = "grr"            -- mapping to rename reference under cursor
        }
      },
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = "gnd",        -- mapping to go to definition of symbol under cursor
          list_definitions = "gnD"        -- mapping to list all definitions in current file
        }
      }
    },
    textobjects = { -- syntax-aware textobjects
	enable = true,
	disable = {},
	keymaps = {
	    ["iL"] = { -- you can define your own textobjects directly here
		python = "(function_definition) @function",
		cpp = "(function_definition) @function",
		c = "(function_definition) @function",
		java = "(method_declaration) @function"
	    },
	    -- or you use the queries from supported languages with textobjects.scm
	    ["af"] = "@function.outer",
	    ["if"] = "@function.inner",
	    ["aC"] = "@class.outer",
	    ["iC"] = "@class.inner",
	    ["ac"] = "@conditional.outer",
	    ["ic"] = "@conditional.inner",
	    ["ae"] = "@block.outer",
	    ["ie"] = "@block.inner",
	    ["al"] = "@loop.outer",
	    ["il"] = "@loop.inner",
	    ["is"] = "@statement.inner",
	    ["as"] = "@statement.outer",
	    ["ad"] = "@comment.outer",
	    ["am"] = "@call.outer",
	    ["im"] = "@call.inner"
	}
    },
    ensure_installed = 'all' -- one of 'all', 'language', or a list of languages
}
require "nvim-treesitter.highlight"
local hlmap = vim.treesitter.TSHighlighter.hl_map

--Misc
hlmap.error = nil
hlmap["punctuation.delimiter"] = "Delimiter"
hlmap["punctuation.bracket"] = "Delimiter"

-- Constants
hlmap["constant"] = "Constant"
hlmap["constant.builtin"] = "Type"
hlmap["constant.macro"] = "Define"
hlmap["string"] = "String"
hlmap["string.regex"] = "String"
hlmap["string.escape"] = "SpecialChar"
hlmap["character"] = "Character"
hlmap["number"] = "Number"
hlmap["boolean"] = "Boolean"
hlmap["float"] = "Float"

-- Functions
hlmap["function"] = "Function"
hlmap["function.builtin"] = "Special"
hlmap["function.macro"] = "Macro"
hlmap["parameter"] = "Identifier"
hlmap["method"] = "Function"
hlmap["field"] = "Identifier"
hlmap["property"] = "Identifier"
hlmap["constructor"] = "Type"

-- Keywords
hlmap["conditional"] = "Conditional"
hlmap["repeat"] = "Repeat"
hlmap["label"] = "Label"
hlmap["operator"] = "Operator"
hlmap["keyword"] = "Repeat"
hlmap["exception"] = "Exception"
hlmap["include"] = "Include"
hlmap["type"] = "Type"
hlmap["type.builtin"] = "Type"
hlmap["structure"] = "Structure"
EOF
highlight link TSError Normal
autocmd FileType python autocmd CursorHold * silent :TSBufEnable highlight

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
hi gruvbox_bright_red     gui=NONE guifg=#fb4934
hi gruvbox_bright_green   gui=NONE guifg=#b8bb26
hi gruvbox_bright_yellow  gui=NONE guifg=#fabd2f
hi gruvbox_bright_blue    gui=NONE guifg=#83a598
hi gruvbox_bright_purple  gui=NONE guifg=#d3869b
hi gruvbox_bright_aqua    gui=NONE guifg=#8ec07c
hi gruvbox_bright_orange  gui=NONE guifg=#fe8019
hi gruvbox_neutral_red    gui=NONE guifg=#cc241d
hi gruvbox_neutral_green  gui=NONE guifg=#98971a
hi gruvbox_neutral_yellow gui=NONE guifg=#d79921
hi gruvbox_neutral_blue   gui=NONE guifg=#458588
hi gruvbox_neutral_purple gui=NONE guifg=#b16286
hi gruvbox_neutral_aqua   gui=NONE guifg=#689d6a
hi gruvbox_neutral_orange gui=NONE guifg=#d65d0e
hi gruvbox_faded_red      gui=NONE guifg=#9d0006
hi gruvbox_faded_green    gui=NONE guifg=#79740e
hi gruvbox_faded_yellow   gui=NONE guifg=#b57614
hi gruvbox_faded_blue     gui=NONE guifg=#076678
hi gruvbox_faded_purple   gui=NONE guifg=#8f3f71
hi gruvbox_faded_aqua     gui=NONE guifg=#427b58
hi gruvbox_faded_orange   gui=NONE guifg=#af3a03

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

" vim:fdm=expr:fdl=0
" vim:fde=getline(v\:lnum)=~'^"#'?'>'.(matchend(getline(v\:lnum),'"#*')-1)\:'='
