P = function(v)
  print(vim.inspect(v))
  return v
end

if pcall(require, 'plenary') then
  local RELOAD = require('plenary.reload').reload_module
  R = function(name)
    RELOAD(name)
    return require(name)
  end
else
  R = function(pkg) return require(pkg) end
end

local k_status, k = pcall(require, 'astronauta.keymap')
if k_status == true then
  k = require 'astronauta.keymap'
  nnoremap = k.nnoremap
  vnoremap = k.vnoremap
  tnoremap = k.tnoremap
  inoremap = k.inoremap
end
