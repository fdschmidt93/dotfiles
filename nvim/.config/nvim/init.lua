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
require 'settings'
