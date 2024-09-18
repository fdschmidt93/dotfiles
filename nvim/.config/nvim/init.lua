local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
vim.deprecate = function() end

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require "fds.settings"
require("lazy").setup(
  "plugins",
  { dev = { path = vim.fs.joinpath(vim.uv.os_homedir(), "repos", "lua"), fallback = true } }
)
require "fds.globals"
require "fds.mappings"
