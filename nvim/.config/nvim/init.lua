-- bootstrap packer if not found
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

vim.api.nvim_exec(
  [[
  augroup Packer
    autocmd!
    autocmd BufWritePost plugins.lua PackerCompile
  augroup end
]],
  false
)

vim.cmd [[packadd packer.nvim]]
-- configuration
pcall(require, "impatient")
require "fds.settings"
require "fds.plugins"
require "fds.globals"
require "packer_compiled"
require "fds.mappings"
