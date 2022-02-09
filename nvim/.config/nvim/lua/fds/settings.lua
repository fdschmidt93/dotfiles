local opt = vim.opt

-- for firenvim
            -- \ 'content': 'text',
vim.cmd [[set guifont=JetBrainsMono_Nerd_Font_Mono:h18]]
vim.cmd [[
let g:firenvim_config = { 
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'firenvim',
            \ 'priority': 0,
            \ 'takeover': 'never',
        \ },
    \ }
\ }
]]

vim.cmd [[set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case]]
vim.cmd [[set grepformat=%f:%l:%c:%m,%f:%l:%m]]

-- disable flickering for lazyloading galaxyline/gitsigns/lsp
opt.laststatus = 0
opt.signcolumn = "yes"

-- no startup message
opt.shortmess:append "I"

-- Incremental live completion
opt.inccommand = "nosplit"

-- Change backspace to behave more intuitively
opt.backspace = [[indent,eol,start]]

opt.clipboard = [[unnamedplus]]

-- Set indent options for vim
opt.title = true
opt.wrap = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.showbreak = [[↪ ]]
opt.expandtab = true
opt.autoindent = true

opt.breakindent = true
opt.linebreak = true

-- Set highlight on search
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true
opt.ignorecase = true

-- Do not save when switching buffers
opt.hidden = true

-- Set show command
opt.showcmd = true
opt.showmode = false

opt.number = true
opt.relativenumber = true

opt.splitbelow = true -- New horizontal splits window below
opt.splitright = true -- New vertical splits window right

opt.scrolloff = 10 -- always 10 lines below/above cursor
opt.pumheight = 10

opt.cursorline = true
opt.termguicolors = true
opt.conceallevel = 3

-- python providers
vim.g["python3_host_prog"] = string.format("/home/%s/miniconda3/bin/python", os.getenv "USER")

vim.cmd [[let &fcs='eob: ']] -- hide end of buffer line markers
vim.cmd [[set fillchars+=vert:\│]]