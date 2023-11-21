-- shorthands for cli
_G.A = vim.api
_G.F = vim.fn
_G.B = vim.api.nvim_get_current_buf
_G.W = vim.api.nvim_get_current_win
_G.P = vim.print

if pcall(require, "plenary") then
  _G.R = function(name)
    require("plenary.reload").reload_module(name)
    return require(name)
  end
end
