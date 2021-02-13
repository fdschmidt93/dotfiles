-- Install packer
local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
              install_path)
end

-- Only required if you have packer in your `opt` pack vim.cmd [[packadd packer.nvim]]
vim.api.nvim_exec([[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]], false)

-- Only required if you have packer in your `opt` pack
vim.cmd [[packadd packer.nvim]]

require 'plugins'
require 'mappings'

-- Allow filetype plugins and syntax highlighting
vim.o.autoindent = true

-- -- Incremental live completion
vim.o.inccommand = "nosplit"

-- -- Change backspace to behave more intuitively
vim.o.backspace = "indent,eol,start"
vim.g.clipboard = "unnamedplus"

-- -- Set tab options for vim
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.breakindent = true
vim.o.linebreak = true

-- -- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.smartcase = true
vim.o.ignorecase = true

-- -- Do not save when switching buffers
vim.o.hidden = true

-- -- Enable mouse mode
vim.o.mouse = "a"

-- -- -- Set show command
-- vim.o.showcmd = true
vim.o.showmode = false

vim.wo.number = true
vim.wo.relativenumber = true

vim.o.splitbelow = true -- New horizontal splits window below
vim.o.splitright = true -- New vertical splits window right

vim.o.scrolloff = 10 -- always 10 lines below/above cursor
vim.g.pumheight = 10

vim.wo.cursorline = true
vim.o.termguicolors = true
vim.o.syntax = 'enable'

vim.cmd [[let &fcs='eob: ']] -- hide end of buffer line markers
vim.cmd [[set fillchars+=vert:\|]]
