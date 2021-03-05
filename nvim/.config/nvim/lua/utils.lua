local M = {}
local utils = {}

-- test strings for visual selection
-- of PR for neovim core
local a = '全ä'
local c = 'ä anda α'
local b = '全角全角全角'
local d = 'hallääääääääää'

M.set_hl = function(group, options)
  local bg = options.bg == nil and '' or 'guibg=' .. options.bg
  local fg = options.fg == nil and '' or 'guifg=' .. options.fg
  local gui = options.gui == nil and '' or 'gui=' .. options.gui
  local link = options.link or false
  local target = options.target

  if not link then
    vim.cmd(string.format('hi %s %s %s %s', group, bg, fg, gui))
  else
    vim.cmd(string.format('hi! link', group, target))
  end
end

return M
