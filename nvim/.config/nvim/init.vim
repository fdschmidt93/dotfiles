"# [0] vim-plug
call plug#begin('~/.config/nvim/plugged')
" Extend Vim 
Plug 'romainl/vim-cool' " disable search highlight when done
Plug 'tpope/vim-commentary' " gc mapping to comment stuff out
Plug 'tpope/vim-fugitive' " git integration for vim
Plug 'tpope/vim-repeat' " enable repeating supported plugin maps with dot
Plug 'tpope/vim-surround' " quoting/parenthesizing made simple
Plug 'tpope/vim-unimpaired' " 
Plug 'justinmk/vim-sneak' " 2 character motions Coding
Plug 'jpalardy/vim-slime' " REPL for vim
Plug 'kkoomen/vim-doge' " Documentation
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Intellisense
Plug 'antoinemadec/coc-fzf' " fzf integration into coc
" Plug 'rafcamlet/coc-nvim-lua'
Plug 'kdheepak/lazygit.nvim'

" Python
Plug 'nvim-treesitter/nvim-treesitter' " fast incremental syntax highlighting and more
Plug 'nvim-treesitter/nvim-treesitter-textobjects' " fast incremental syntax highlighting and more
" Themes
Plug 'morhetz/gruvbox' " main theme
Plug 'crusoexia/vim-monokai' " alternatives
Plug 'iCyMind/NeoSolarized'
" fzf
Plug '~/.fzf'
Plug 'junegunn/fzf.vim' " vim integration
" Other
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'
Plug 'norcalli/nvim-colorizer.lua' " show hex rgb colors
Plug 'chrisbra/csv.vim'
Plug 'itchyny/calendar.vim'
Plug 'mattn/emmet-vim'
" Writing
Plug 'lervag/vimtex' " Latex integration (+ coc-texlab)
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'} " prettify latex syntax
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  } " live markdown
" Plug 'neovim/nvim-lsp'
" Plug 'nvim-lua/diagnostic-nvim'
" Plug 'nvim-lua/completion-nvim'
" Plug 'steelsojka/completion-buffers'
Plug 'kyazdani42/nvim-web-devicons' " Recommended (for coloured icons)
Plug 'Akin909/nvim-bufferline.lua' " beautiful tabline
" Plug 'kyazdani42/nvim-tree.lua'
call plug#end()


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


"# [2] Theme & Syntax Highlighting
" Theme
set cursorline " highlight current line
set termguicolors
set background=dark
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
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
lua require'colorizer'.setup() -- rgb hex color codes in nvim
hi Pmenu ctermbg=NONE guibg=#3c3836 " merge with cursorline style
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
    highlights = {
        bufferline_selected = {
          guifg = normal_fg,
          guibg = normal_bg,
          gui = "bold",
        }
    }
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
nmap <Leader>ti :lua repl.shell("right", "ipy") <CR>" Open right-sided terminal with <leader>t
nmap <Leader><C-t> :lua repl.shell("below", nil)<CR> " Open (smaller) terminal below
nmap <Leader><C-t>i :lua repl.shell("below", "ipy")<CR> " Open (smaller) terminal below
nmap <Leader>w :w<CR>| " Save buffer with <leader>w
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


"# [4] Plugins

"# [4.1] vim-repeat
silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)

"# [4.2] vim-slime
let g:slime_target = "neovim"
let g:slime_python_ipython = 1"
lua repl = require('repl') -- shortcuts for vim-slime

"# [4.3] fzf
nnoremap <Leader>f :Files<cr>
nnoremap <Leader>b :Buffers<cr>
nnoremap <Leader>rg :Rg<cr>
nnoremap <Leader>co :Colors<cr>
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

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


"# [4.5] vim-airline
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#coc#enabled = 1
let g:airline_powerline_fonts = 1"

"# [4.6] vim-doge
let g:doge_enable_mappings = 1 "

"# [4.7] coc.nvim
let g:coc_global_extensions = ['coc-json', 'coc-vimtex', 'coc-texlab', 'coc-snippets', 'coc-pyright', 'coc-lua', 'coc-emmet']

set updatetime=300

inoremap <silent><expr> <c-space> coc#refresh()| " Use <c-space> for trigger completion.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"| " <cr> to confirm

nmap <silent> [c <Plug>(coc-diagnostic-prev)| " Use `[c` and `]c` for navigate diagnostics
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)| " Remap keys for gotos
nmap <silent> gD <Plug>(coc-declaration)|
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <leader>rn <Plug>(coc-rename)| " Remap for rename current word

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>| " K to show docs in preview window
autocmd CursorHold * silent call CocActionAsync('highlight') " Highlight symbol under cursor on CursorHold

augroup mygroup autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

vmap <leader>cf  <Plug>(coc-format-selected)| " Remap for format selected region
nmap <leader>cf  <Plug>(coc-format-selected)

vmap <leader>a  <Plug>(coc-codeaction-selected) " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <leader>ac  <Plug>(coc-codeaction) " Remap for do codeAction of current line
nmap <leader>qf  <Plug>(coc-fix-current) " Fix autofix problem of current line

command! -nargs=0 Format :call CocAction('format') " Use `:Format` for format current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>) " Use `:Fold` for fold current buffer

let g:coc_fzf_preview = ''
let g:coc_fzf_opts = []
nnoremap <silent> <space>L :<C-u>CocFzfList<CR>
nnoremap <silent> <space>a :<C-u>CocFzfList diagnostics<CR>
nnoremap <silent> <space>b :<C-u>CocFzfList diagnostics --current-buf<CR>
nnoremap <silent> <space>c :<C-u>CocFzfList commands<CR>
nnoremap <silent> <space>e :<C-u>CocFzfList extensions<CR>
nnoremap <silent> <space>l :<C-u>CocFzfList location<CR>
nnoremap <silent> <space>o :<C-u>CocFzfList outline<CR>
nnoremap <silent> <space>s :<C-u>CocFzfList symbols<CR>
nnoremap <silent> <space>S :<C-u>CocFzfList services<CR>
nnoremap <silent> <space>p :<C-u>CocFzfListResume<CR>"

nnoremap <silent> <space><space>m :<C-u>CocFzfList symbols --kind Method<CR>
nnoremap <silent> <space><space>c :<C-u>CocFzfList symbols --kind Class<CR>
nnoremap <silent> <space><space>f :<C-u>CocFzfList symbols --kind Function<CR>
nnoremap <silent> <space><space>s :<C-u>CocList symbols<CR>

" coc-snippets
imap <C-l> <Plug>(coc-snippets-expand) " Use <C-l> for trigger snippet expand.
vmap <C-j> <Plug>(coc-snippets-select) " Use <C-j> for select text for visual placeholder of snippet.
let g:coc_snippet_next = '<c-j>' " Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>' " Use <C-k> for jump to previous placeholder, it's default of coc.nvim
imap <C-j> <Plug>(coc-snippets-expand-jump)" " Use <C-j> for both expand and jump (make expand higher priority.)

autocmd FileType python let b:coc_root_patterns = ['.git', '.env'] " python workspace

"# [4.8] nvim-treesitter
lua << EOF
require "nvim-treesitter.configs"
require "nvim-treesitter.configs".setup(
    {
        highlight = {
            enable = true -- false will disable the whole extension
        },
        incremental_selection = {
            -- this enables incremental selection
            enable = true,
            disable = {},
            keymaps = {
                init_selection = "<enter>", -- maps in normal mode to init the node/scope selection
                node_incremental = "<enter>", -- increment to the upper named parent
                scope_incremental = "Ts", -- increment to the upper scope 
                node_decremental = "grm"
            }
        },
        node_movement = {
            -- this enables incremental selection
            enable = true,
            highlight_current_node = true,
            disable = {},
            keymaps = {
                move_up = "<a-k>",
                move_down = "<a-j>",
                move_left = "<a-h>",
                move_right = "<a-l>",
                swap_up = "<s-a-k>",
                swap_down = "<s-a-j>",
                swap_left = "<s-a-h>",
                swap_right = "<s-a-l>",
                select_current_node = "<leader>ff"
            }
        },
        textobjects = {
            select = {
                enable = true,
                disable = {},
                keymaps = {
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
                    ["id"] = "@comment.inner",
                    ["am"] = "@call.outer",
                    ["im"] = "@call.inner"
                },
            },
        },
        fold = {
            enable = true
        },
        refactor = {
            highlight_current_scope = {
                enable = false,
                inverse_highlighting = true,
                disable = {"python"}
            },
            highlight_definitions = {
                enable = true,
            },
            smart_rename = {
                enable = true,
                disable = {},
                keymaps = {
                    smart_rename = "grr"
                }
            },
            navigation = {
                enable = true,
                disable = {},
                keymaps = {
                    goto_definition = "gnd",
                    list_definitions = "gnD"
                }
            }
        },
        ensure_installed = "all"
    }
)

require "nvim-treesitter.highlight"
local hlmap = vim.treesitter.highlighter.hl_map

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
hlmap["function.builtin"] = "Special"
hlmap["function.macro"] = "Macro"
hlmap["parameter"] = "Identifier"
hlmap["property"] = "Identifier"
hlmap["constructor"] = "Type"

hlmap["function"] = "Function"
hlmap["field"] = "Identifier"
hlmap["method"] = "Function"

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
" autocmd FileType python autocmd InsertLeave * silent :TSBufEnable highlight

" highlight SneakScope guifg=#1d2021 guibg=#b57614
" highlight Sneak guifg=#1d2021 guibg=#fe8019
" highlight SneakLabel guifg=#1d2021 guibg=#fe8019

"# [4.9] vimwiki / calendar.vim
" let g:vimwiki_list = [{'path': '~/vimwiki/',  'syntax': 'markdown', 'ext': '.md'}]

  " let g:vimwiki_ext2syntax = {'': 'markdown'}
let g:vimwiki_filetypes = ['markdown', 'pandoc']
hi link VimwikiHeader1 gruvbox_bright_green_bold
hi link VimwikiHeader2 gruvbox_bright_aqua_bold
hi link VimwikiHeader3 gruvbox_bright_yellow_bold
hi link VimwikiHeader4 gruvbox_bright_orange_bold
hi link VimwikiHeader5 gruvbox_bright_red_bold
hi link VimwikiHeader6 gruvbox_bright_purple_bold
let g:vimwiki_listsyms = '✗○◐●✓'
let g:vimwiki_global_ext = 1
let g:calendar_google_calendar = 1

"# [4.10] gruvbox colors

" fg
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
hi gruvbox_bright_red_bg     gui=NONE guibg=#fb4934
hi gruvbox_bright_green_bg   gui=NONE guibg=#b8bb26
hi gruvbox_bright_yellow_bg  gui=NONE guibg=#fabd2f
hi gruvbox_bright_blue_bg    gui=NONE guibg=#83a598
hi gruvbox_bright_purple_bg  gui=NONE guibg=#d3869b
hi gruvbox_bright_aqua_bg    gui=NONE guibg=#8ec07c
hi gruvbox_bright_orange_bg  gui=NONE guibg=#fe8019
hi gruvbox_neutral_red_bg    gui=NONE guibg=#cc241d
hi gruvbox_neutral_green_bg  gui=NONE guibg=#98971a
hi gruvbox_neutral_yellow_bg gui=NONE guibg=#d79921
hi gruvbox_neutral_blue_bg   gui=NONE guibg=#458588
hi gruvbox_neutral_purple_bg gui=NONE guibg=#b16286
hi gruvbox_neutral_aqua_bg   gui=NONE guibg=#689d6a
hi gruvbox_neutral_orange_bg gui=NONE guibg=#d65d0e
hi gruvbox_faded_red_bg      gui=NONE guibg=#9d0006
hi gruvbox_faded_green_bg    gui=NONE guibg=#79740e
hi gruvbox_faded_yellow_bg   gui=NONE guibg=#b57614
hi gruvbox_faded_blue_bg     gui=NONE guibg=#076678
hi gruvbox_faded_purple_bg   gui=NONE guibg=#8f3f71
hi gruvbox_faded_aqua_bg     gui=NONE guibg=#427b58
hi gruvbox_faded_orange_bg   gui=NONE guibg=#af3a03

hi gruvbox_yank guibg=#8ec07c guifg=#f9f5d7

" vim:fdm=expr:fdl=0
" vim:fde=getline(v\:lnum)=~'^"#'?'>'.(matchend(getline(v\:lnum),'"#*')-1)\:'='
