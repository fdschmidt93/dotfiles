local colors = require 'colors.gruvbox'
local utils = require 'utils'
local cmd = vim.cmd

vim.cmd [[colorscheme gruvbox]]
vim.g.background = 'dark'
require'nvim-web-devicons'.setup()

vim.cmd[[hi clear StatusLine]]

local highlights = {
  {'Normal', {bg = 'NONE'}}, {'Comment', {gui = 'italic'}},
  {'NormalFloat', {bg = 'NONE'}},
  {'CursorLineNR', {fg = colors.bright_yellow, gui = 'bold'}},
  {'StatusLineNC', {bg = colors.dark0}},
  {'CursorLine', {bg = colors.dark1}}, {'SignColumn', {bg = 'NONE'}},
  {'VertSplit', {fg = colors.gruvbox_dark1, bg = 'NONE'}},
  {'Pmenu', {fg = 'NONE', bg = colors.dark1}},
  {'gruvbox_yank', {fg = colors.light1, bg = colors.bright_aqua}}, -- telescope
  {'TelescopePromptBorder', {fg = colors.bright_blue}},
  {'TelescopeResultsBorder', {fg = colors.bright_aqua}},
  {'TelescopePreviewBorder', {fg = colors.bright_aqua}}, -- gitsigns
  {'GitSignsAdd', {fg = colors.bright_green, bg = 'NONE'}},
  {'GitSignsChange', {fg = colors.bright_blue, bg = 'NONE'}},
  {'GitSignsDelete', {fg = colors.bright_red, bg = 'NONE'}}, -- neogit
  {'DiffAdd', {bg = colors.bright_green, fg = colors.dark1}},
  {'DiffChange', {bg = colors.bright_blue, fg = colors.dark1}},
  {'DiffDelete', {bg = colors.bright_red, fg = colors.dark1}},
  {'NeogitDiffAddHighlight', {bg = colors.dark1, fg = colors.bright_green}},
  {'NeogitDiffDeleteHighlight', {bg = colors.dark1, fg = colors.bright_red}},
  -- lspsaga.nvim
  {'LspSagaLightBulb', {fg = colors.bright_blue}},
  {'LspSagaDiagnosticBorder', {fg = colors.dark3}},
  {'LspSagaDiagnosticHeader', {fg = colors.light1, gui = 'bold'}},
  {'LspSagaDiagnosticTruncateLine', {fg = colors.dark3}},
  {'LspSagaRenameBorder', {fg = colors.neutral_blue}},
  {'LspSagaHoverBorder', {fg = colors.dark3}}, -- nvim-dap
  {'Breakpoint', {fg = colors.bright_red}},
  {'Stopped', {fg = colors.bright_green}}, -- LspTrouble
  {'LspTroubleFoldIcon', {fg = colors.bright_yellow, bg = 'None', gui = 'bold'}}

}
for _, hl in pairs(highlights) do utils.set_hl(hl[1], hl[2]) end


-- Set terminal colors in line with kitty
-- black
vim.g.terminal_color_0 = '#282828'
vim.g.terminal_color_8 = '#928374'

-- red
vim.g.terminal_color_1 = '#cc231d'
vim.g.terminal_color_9 = '#fb4834'

-- green
vim.g.terminal_color_2 = '#98971a'
vim.g.terminal_color_10 = '#b8ba26'

-- yellow
vim.g.terminal_color_3 = '#d79920'
vim.g.terminal_color_11 = '#fabc2e'

-- blue
vim.g.terminal_color_4 = '#458588'
vim.g.terminal_color_12 = '#83a598'

-- magenta
vim.g.terminal_color_5 = '#b16186'
vim.g.terminal_color_13 = '#d3859b'

-- cyan
vim.g.terminal_color_6 = '#689d6a'
vim.g.terminal_color_14 = '#8ec07c'

-- white
vim.g.terminal_color_15 = '#a89984'
vim.g.terminal_color_7 = '#ebdbb2'

vim.api.nvim_exec([[
augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({higroup='gruvbox_yank', timeout=250})
augroup END
]], false)

