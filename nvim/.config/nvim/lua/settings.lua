local opt = vim.opt

-- faster startup
vim.g.loaded_gzip = false
vim.g.loaded_matchit = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_man = false
vim.g.loaded_2html_plugin = false
vim.g.loaded_remote_plugins = false

-- disable flickering for lazyloading galaxyline/gitsigns/lsp
vim.opt.laststatus = 0
vim.opt.signcolumn = "yes"

-- no startup message
vim.opt.shortmess:append "I"

-- Incremental live completion
opt.inccommand = "nosplit"

-- Change backspace to behave more intuitively
opt.backspace = [[indent,eol,start]]

opt.clipboard = [[unnamedplus]]

-- Set indent options for vim
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
