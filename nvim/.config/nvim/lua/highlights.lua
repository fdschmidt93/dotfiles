local colors = require 'colors.gruvbox'
local utils = require 'utils'

vim.cmd [[colorscheme gruvbox]]
vim.g.background = 'dark'
require'nvim-web-devicons'.setup()

local highlights = {
  {'Normal', {bg = 'NONE'}}, {'Comment', {gui = 'italic'}},
  {'CursorLineNR', {fg = colors.bright_yellow, gui = 'bold'}},
  {'CursorLine', {bg = colors.dark1}},
  {'SignColumn', {bg = 'NONE'}},
  {'VertSplit', {fg = colors.gruvbox_dark1, bg = 'NONE'}},
  {'Pmenu', {fg = 'NONE', bg = colors.dark1}},
  {'gruvbox_yank', {fg = colors.light1, bg = colors.bright_aqua}},

  {'TelescopePromptBorder', {fg = colors.bright_blue}},
  {'TelescopeResultsBorder', {fg = colors.bright_aqua}},
  {'TelescopePreviewBorder', {fg = colors.bright_aqua}},

  -- gitsigns
  {'GitSignsAdd', {fg = colors.bright_green, bg = 'NONE'}},
  {'GitSignsChange', {fg = colors.bright_blue, bg = 'NONE'}},
  {'GitSignsDelete', {fg = colors.bright_red, bg = 'NONE'}},

  -- neogit
  {'DiffAdd', {bg = colors.bright_green, fg = colors.dark1}},
  {'DiffChange', {bg = colors.bright_blue, fg = colors.dark1}},
  {'DiffDelete', {bg = colors.bright_red, fg = colors.dark1}},
  {'NeogitDiffAddHighlight', {bg = colors.dark1, fg = colors.bright_green}},
  {'NeogitDiffDeleteHighlight', {bg = colors.dark1, fg = colors.bright_red}},

  -- lspsaga.nvim
  {'LspSagaLightBulb', {fg = colors.bright_blue}},
  {'LspSagaDiagnosticBorder', {fg = colors.dark3}},
  {'LspSagaDiagnosticHeader', {fg = colors.light1, gui='bold'}},
  {'LspSagaDiagnosticTruncateLine', {fg = colors.dark3}},
  {'LspSagaRenameBorder', {fg = colors.neutral_blue}},
  {'LspSagaHoverBorder', {fg = colors.dark3}},

  -- nvim-dap
  {'Breakpoint', {fg = colors.bright_red}},
  {'Stopped', {fg = colors.bright_green}}
}
for _, hl in pairs(highlights) do utils.set_hl(hl[1], hl[2]) end


vim.api.nvim_exec([[
augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({higroup='gruvbox_yank', timeout=250})
augroup END
]], false)

