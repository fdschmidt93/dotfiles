local palette = require "fds.highlights.gruvbox"

vim.cmd [[colorscheme gruvbox]]
vim.g.background = "dark"
require("nvim-web-devicons").setup()

vim.cmd [[hi clear StatusLine]]

local highlight_groups = {

  -- nvim
  { "Comment", { fg = palette.gray_245, italic = true } },
  { "NormalFloat", { bg = palette.dark0_soft } },
  { "CursorLine", { default = true } },
  { "SignColumn", { bg = "NONE" } },
  { "WinSeparator", { fg = palette.dark1, bg = "NONE" } },
  { "FloatBorder", { fg = palette.dark4, bg = palette.dark0_soft } },

  -- telescope
  { "TelescopeSelection", { bg = palette.dark1 } }, -- gitsigns
  { "TelescopeNormal", { fg = palette.light1, bg = palette.dark0_hard } },
  { "TelescopePromptNormal", { bg = palette.dark1 } }, -- gitsigns
  { "TelescopeResultsBorder", { fg = palette.bright_aqua, bg = palette.dark0_hard } },
  { "TelescopePreviewBorder", { fg = palette.bright_aqua, bg = palette.dark0_hard } },
  { "TelescopePromptBorder", { fg = palette.bright_blue, bg = palette.dark1 } },
  { "TelescopePromptTitle", { fg = palette.dark1, bg = palette.bright_blue } },
  { "TelescopeResultsTitle", { fg = palette.dark1, bg = palette.bright_aqua } },
  { "TelescopePreviewTitle", { fg = palette.dark1, bg = palette.bright_aqua } },

  -- cmp
  { "Pmenu", { fg = palette.light1, bg = palette.dark0_soft } },
  { "CmpItemAbbr", { fg = palette.gray_245 } },
  { "CmpItemAbbrMatch", { fg = palette.bright_yellow, bold = true } },
  { "CmpItemAbbrMatchFuzzy", { fg = palette.bright_yellow, bold = true } },
  { "CmpItemKind", { fg = palette.bright_yellow, bold = true } },
  { "CmpItemMenu", { fg = palette.light1, bg = palette.neutral_aqua } },
  { "CmpItemMenuDefault", { fg = palette.light1, bg = palette.neutral_aqua } },
  { "CmpBorderedWindow_Normal", { fg = palette.light1, bg = palette.dark0_soft } },
  { "CmpBorderedWindow_FloatBorder", { fg = palette.dark4, bg = palette.dark0_soft } },
  { "CmpCompletionWindowBorder", { fg = palette.dark4, bg = palette.dark4 } },
  { "CmpDocumentationWindowBorder", { fg = palette.dark4, bg = palette.dark4 } },

  -- git
  { "GitSignsAdd", { fg = palette.bright_green, bg = "NONE" } },
  { "GitSignsChange", { fg = palette.bright_blue, bg = "NONE" } },
  { "GitSignsDelete", { fg = palette.bright_red, bg = "NONE" } },

  -- lspconfig
  { "DiagnosticError", { fg = palette.bright_red } },
  { "DiagnosticWarn", { fg = palette.neutral_yellow } },
  { "DiagnosticHint", { fg = palette.neutral_aqua } },
  { "DiagnosticInfo", { fg = palette.light3 } },
  { "DiagnosticWarning", { fg = palette.neutral_yellow } },
  { "DiagnosticInformation", { fg = palette.light3 } },
  { "LspDiagnosticsDefaultError", { fg = palette.bright_red } },
  { "LspDiagnosticsDefaultWarning", { fg = palette.neutral_yellow } },
  { "LspDiagnosticsDefaultHint", { fg = palette.neutral_aqua } },
  { "LspDiagnosticsDefaultInformation", { fg = palette.light3 } },
  { "LspDiagnosticsFloatingError", { fg = palette.bright_red } },
  { "LspDiagnosticsFloatingWarning", { fg = palette.neutral_yellow } },
  { "LspDiagnosticsFloatingHint", { fg = palette.neutral_aqua } },
  { "LspDiagnosticsFloatingInformation", { fg = palette.light3 } },

  -- dap
  { "Breakpoint", { fg = palette.bright_red } },
  { "Stopped", { fg = palette.bright_green } }, -- LspTrouble

  -- tree-sitter
  { "Operator", { bg = "NONE" } }, -- avoid conflict with cursorline

  -- IndentBlankLine
  { "IndentBlanklineContextChar", { fg = palette.dark4, bg = "None" } },
  { "gruvbox_yank", { fg = palette.light1, bg = palette.bright_aqua } },
}
for _, hl in pairs(highlight_groups) do
  vim.api.nvim_set_hl(0, hl[1], hl[2])
end

local signs = { "", "", "", "" }
local diagnostic_types = { "Error", "Warn", "Info", "Hint" }
for i = 1, #diagnostic_types do
  local diagnostic_type = string.format("DiagnosticSign%s", diagnostic_types[i])
  local opts = {
    text = signs[i],
    texthl = string.format("Diagnostic%s", diagnostic_types[i]),
    linehl = "",
    numhl = "",
  }
  vim.fn.sign_define(diagnostic_type, opts)
end

-- Set terminal colors in line with kitty
-- black
vim.g.terminal_color_0 = "#282828"
vim.g.terminal_color_8 = "#928374"

-- red
vim.g.terminal_color_1 = "#cc231d"
vim.g.terminal_color_9 = "#fb4834"

-- green
vim.g.terminal_color_2 = "#98971a"
vim.g.terminal_color_10 = "#b8ba26"

-- yellow
vim.g.terminal_color_3 = "#d79920"
vim.g.terminal_color_11 = "#fabc2e"

-- blue
vim.g.terminal_color_4 = "#458588"
vim.g.terminal_color_12 = "#83a598"

-- magenta
vim.g.terminal_color_5 = "#b16186"
vim.g.terminal_color_13 = "#d3859b"

-- cyan
vim.g.terminal_color_6 = "#689d6a"
vim.g.terminal_color_14 = "#8ec07c"

-- white
vim.g.terminal_color_15 = "#a89984"
vim.g.terminal_color_7 = "#ebdbb2"

vim.cmd [[
augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({higroup='gruvbox_yank', timeout=250})
augroup END
]]
