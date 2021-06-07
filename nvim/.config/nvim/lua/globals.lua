P = function(v)
  print(vim.inspect(v))
  return v
end

-- loaded = function(package)
--   if type(package) == 'table' then
--     for _, p in pairs(package) do
--       if not loaded(p) then
--         return false
--       end
--     end
--     return true
--   end
--   return packer_plugins[package] and packer_plugins[package].loaded
-- end

if pcall(require, 'plenary') then
  RELOAD = require('plenary.reload').reload_module

  R = function(name)
    RELOAD(name)
    return require(name)
  end
end

if pcall(require, 'astronauta.keymap') then
  k = require 'astronauta.keymap'
  nnoremap = k.nnoremap
  vnoremap = k.vnoremap
  tnoremap = k.tnoremap
  inoremap = k.inoremap
end
