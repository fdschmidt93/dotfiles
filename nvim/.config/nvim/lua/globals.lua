-- I'm lazy
A = vim.api
F = vim.fn
B = vim.api.nvim_get_current_buf
W = vim.api.nvim_get_current_win
L = vim.api.nvim_get_current_line

P = function(v)
  print(vim.inspect(v))
  return v
end

-- partial function for mapping keys
partial = function(f, ...)
  local a = { ... }
  local a_len = select("#", ...)
  return function(...)
    local tmp = { ... }
    local tmp_len = select("#", ...)
    -- Merge arg lists
    for i = 1, tmp_len do
      a[a_len + i] = tmp[i]
    end
    return f(unpack(a, 1, a_len + tmp_len))
  end
end

if pcall(require, "plenary") then
  R = function(name)
    require("plenary.reload").reload_module(name)
    return require(name)
  end
end

local k_status, k = pcall(require, "astronauta.keymap")
if k_status == true then
  local k = require "astronauta.keymap"
  nnoremap = k.nnoremap
  vnoremap = k.vnoremap
  tnoremap = k.tnoremap
  inoremap = k.inoremap
end

function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deepcopy(orig_key)] = deepcopy(orig_value)
    end
    setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end
