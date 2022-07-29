-- shorthands for cli
A = vim.api
F = vim.fn
B = vim.api.nvim_get_current_buf
W = vim.api.nvim_get_current_win
P = vim.pretty_print

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
