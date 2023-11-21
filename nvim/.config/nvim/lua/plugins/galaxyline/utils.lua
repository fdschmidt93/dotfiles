local M = {}

local api = vim.api
local lsp = vim.lsp

M.separators = {
  space = " ",
  vertical_bar = "┃",
  vertical_bar_thin = "│",
  left = "",
  right = "",
  block = "█",
  left_filled = "",
  right_filled = "",
  slant_left = "",
  slant_left_thin = "",
  slant_right = "",
  slant_right_thin = "",
  slant_left_2 = "",
  slant_left_2_thin = "",
  slant_right_2 = "",
  slant_right_2_thin = "",
  left_rounded = "",
  left_rounded_thin = "",
  right_rounded = "",
  right_rounded_thin = "",
  circle = "●",
}

M.gitsigns = function(type, fmt)
  local status = vim.b["gitsigns_status_dict"]
  if status ~= nil then
    local val = status[type]
    if val == 0 or val == false or val == nil then
      return ""
    end
    if fmt ~= nil then
      return string.format(fmt, val)
    end
    return val
  end
  return ""
end

M.get_diagnostic_count = function(bufnr, opts, icon)
  local count = #vim.diagnostic.get(bufnr, opts)
  if count == 0 then
    return ""
  end
  return string.format("  %s %s", icon, count)
end

M.separate = function(opts)
  opts.name = vim.F.if_nil(opts.name, opts.key)
  opts.hl = opts.hl or {}
  return {
    [opts.name] = {
      provider = function() return (opts.condition and opts.condition() or nil) and M.separators[opts.key] end,
      highlight = opts.hl,
    },
  }
end

M.line_column = function()
  local line, column = unpack(api.nvim_win_get_cursor(0))
  return string.format("%3d:%2d", line, column + 1)
end

M.checkwidth = function(width) return vim.fn.winwidth(0) / 2 > width end

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, "r"))
  local s = assert(f:read "*a")
  f:close()
  if raw then
    return s
  end
  s = string.gsub(s, "^%s+", "")
  s = string.gsub(s, "%s+$", "")
  s = string.gsub(s, "[\n\r]+", " ")
  return s
end

M.get_python_env = function()
  local conda = os.getenv "CONDA_PROMPT_MODIFIER"
  local python = os.capture "python -V"
  if conda ~= nil then
    return python .. " " .. vim.trim(conda)
  end
  return python
end

return M
