local palette = require 'highlights.gruvbox'
local utils = R 'utils'
local cmd = vim.cmd

vim.cmd [[colorscheme gruvbox]]
vim.g.background = 'dark'
require'nvim-web-devicons'.setup()

vim.cmd [[hi clear StatusLine]]

local highlight_groups = {
  {'Normal', {bg = 'NONE'}}, {'Comment', {gui = 'italic'}},
  {'NormalFloat', {bg = 'NONE'}},
  {'CursorLineNR', {fg = palette.bright_yellow, gui = 'bold'}},
  {'StatusLine', {bg = 'NONE'}}, {'StatusLineNC', {bg = 'NONE'}},
  {'CursorLine', {bg = palette.dark1}}, {'SignColumn', {bg = 'NONE'}},
  {'VertSplit', {fg = palette.gruvbox_dark1, bg = 'NONE'}},
  {'Pmenu', {fg = 'NONE', bg = palette.dark1}},
  {'gruvbox_yank', {fg = palette.light1, bg = palette.bright_aqua}}, -- telescope
  {'TelescopePromptBorder', {fg = palette.bright_blue}},
  {'TelescopeResultsBorder', {fg = palette.bright_aqua}},
  {'TelescopePreviewBorder', {fg = palette.bright_aqua}}, -- gitsigns
  {'GitSignsAdd', {fg = palette.bright_green, bg = 'NONE'}},
  {'GitSignsChange', {fg = palette.bright_blue, bg = 'NONE'}},
  {'GitSignsDelete', {fg = palette.bright_red, bg = 'NONE'}}, -- neogit
  {'DiffAdd', {bg = palette.bright_green, fg = palette.dark1}},
  {'DiffChange', {bg = palette.bright_blue, fg = palette.dark1}},
  {'DiffDelete', {bg = palette.bright_red, fg = palette.dark1}},
  {'NeogitDiffAddHighlight', {bg = palette.dark1, fg = palette.bright_green}},
  {'NeogitDiffDeleteHighlight', {bg = palette.dark1, fg = palette.bright_red}},
  -- lspsaga.nvim
  {'LspSagaLightBulb', {fg = palette.bright_blue}},
  {'LspSagaDiagnosticBorder', {fg = palette.dark3}},
  {'LspSagaDiagnosticHeader', {fg = palette.light1, gui = 'bold'}},
  {'LspSagaDiagnosticTruncateLine', {fg = palette.dark3}},
  {'LspSagaRenameBorder', {fg = palette.neutral_blue}},
  {'LspSagaHoverBorder', {fg = palette.dark3}}, -- nvim-dap
  {'Breakpoint', {fg = palette.bright_red}},
  {'Stopped', {fg = palette.bright_green}}, -- LspTrouble
  {'LspTroubleFoldIcon', {fg = palette.bright_yellow, bg = 'None', gui = 'bold'}},


  {'NvimTreeIndentMarker', {fg = palette.dark2, bg = 'None', gui = 'bold'}},
  {'NvimTreeFolderIcon', {fg = palette.bright_aqua, bg = 'None', gui = 'bold'}},
  {'NvimTreeFolderName', {fg = palette.bright_blue, bg = 'None', gui = 'bold'}},
  {'NvimTreeOpenedFolderName', {fg = palette.bright_aqua, bg = 'None', gui = 'bold'}},

  {'IndentBlanklineContextChar', {fg = palette.dark4, bg = 'None'}},

}
for _, hl in pairs(highlight_groups) do utils.set_hl(hl[1], hl[2]) end

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

vim.cmd[[
augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({higroup='gruvbox_yank', timeout=250})
augroup END
]]

