local palette = require "fds.highlights.gruvbox"

vim.cmd [[colorscheme gruvbox]]
vim.g.background = "dark"
require("nvim-web-devicons").setup()

vim.cmd [[hi clear StatusLine]]

local function hex_to_rg(hex)
  hex = hex:gsub("#", "")
  return {
    r = tonumber("0x" .. hex:sub(1, 2)),
    g = tonumber("0x" .. hex:sub(3, 4)),
    b = tonumber("0x" .. hex:sub(5, 6)),
  }
end

local function rgb_to_hex(rgb)
  return string.format("#%02X%02X%02X", rgb.r, rgb.g, rgb.b)
end

local function blend_colors(color1, color2, alpha)
  local c1 = hex_to_rg(color1)
  local c2 = hex_to_rg(color2)

  local blended = {
    r = math.floor(alpha * c1.r + (1 - alpha) * c2.r),
    g = math.floor(alpha * c1.g + (1 - alpha) * c2.g),
    b = math.floor(alpha * c1.b + (1 - alpha) * c2.b),
  }

  return rgb_to_hex(blended)
end

-- Hide all semantic highlights
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end

local highlight_groups = {
  -- tree-sitter
  -- Misc {{{
  { "@comment", { link = "Comment" } },
  -- hl('@error', {link = 'Error'})
  { "@none", { bg = "NONE", fg = "NONE" } },
  { "@preproc", { link = "PreProc" } },
  { "@define", { link = "Define" } },
  { "@operator", { fg = "fg" } },
  { "@title.emphasis", { fg = palette.bright_green, bold = true, italic = true } },
  -- }}}

  -- Punctuation {{{
  { "@punctuation.delimiter", { link = "Delimiter" } },
  { "@punctuation.bracket", { link = "Delimiter" } },
  { "@punctuation.special", { link = "Delimiter" } },
  -- }}}

  -- Literals {{{
  { "@string", { link = "String" } },
  { "@string.regex", { link = "String" } },
  { "@string.escape", { link = "SpecialChar" } },
  { "@string.special", { link = "SpecialChar" } },
  { "@character", { link = "Character" } },
  { "@character.special", { link = "SpecialChar" } },
  { "@boolean", { link = "Boolean" } },
  { "@number", { link = "Number" } },
  { "@float", { link = "Float" } },
  -- }}}

  -- Functions {{{
  { "@function", { link = "Function" } },
  { "@function.call", { link = "Function" } },
  { "@function.builtin", { link = "Special" } },
  { "@function.macro", { link = "Macro" } },
  { "@method", { link = "Function" } },
  { "@method.call", { link = "Function" } },
  { "@constructor", { link = "Special" } },
  { "@parameter", { link = "Identifier" } },
  -- }}}

  -- Keywords {{{
  { "@keyword", { link = "Keyword" } },
  { "@keyword.function", { link = "Keyword" } },
  { "@keyword.operator", { link = "Keyword" } },
  { "@keyword.return", { link = "Keyword" } },
  { "@conditional", { link = "Conditional" } },
  { "@repeat", { link = "Repeat" } },
  { "@debug", { link = "Debug" } },
  { "@label", { link = "Label" } },
  { "@include", { link = "Include" } },
  { "@exception", { link = "Exception" } },
  -- }}}

  -- Types {{{
  { "@type", { link = "Type" } },
  { "@type.builtin", { link = "Type" } },
  { "@type.qualifier", { link = "Type" } },
  { "@type.definition", { link = "Typedef" } },
  { "@storageclass", { link = "StorageClass" } },
  { "@attribute", { link = "PreProc" } },
  { "@field", { link = "Identifier" } },
  { "@property", { link = "Function" } },
  -- }}}

  -- Identifiers {{{
  { "@variable", { fg = "fg", bg = "NONE" } },
  { "@variable.builtin", { link = "Special" } },
  { "@constant", { link = "Constant" } },
  { "@constant.builtin", { link = "Special" } },
  { "@constant.macro", { link = "Define" } },
  { "@namespace", { link = "Include" } },
  { "@symbol", { link = "Identifier" } },
  -- }}}

  -- Text {{{
  { "@text", { fg = "fg", bg = "NONE" } },
  { "@text.strong", { bold = true } },
  { "@text.emphasis", { italic = true } },
  { "@text.underline", { underline = true } },
  { "@text.strike", { strikethrough = true } },
  { "@text.title", { link = "Title" } },
  { "@text.literal", { link = "String" } },
  { "@text.uri", { link = "Underlined" } },
  { "@text.math", { link = "Special" } },
  { "@text.environment", { link = "Macro" } },
  { "@text.environment.name", { link = "Type" } },
  { "@text.reference", { link = "Constant" } },
  { "@text.todo", { link = "Todo" } },
  { "@text.note", { link = "SpecialComment" } },
  { "@text.warning", { link = "WarningMsg" } },
  { "@text.danger", { link = "ErrorMsg" } },
  -- }}}

  -- Tags {{{
  { "@tag", { link = "Tag" } },
  { "@tag.attribute", { link = "Identifier" } },
  { "@tag.delimiter", { link = "Delimiter" } },
  -- }}}

  -- nvim
  { "Comment", { fg = palette.gray_245, italic = true } },
  { "NormalFloat", { bg = palette.dark0_soft } },
  { "SignColumn", { bg = "NONE" } },
  { "WinSeparator", { fg = palette.dark1, bg = "NONE" } },
  { "FloatBorder", { fg = palette.dark4, bg = palette.dark0_soft } },

  -- telescope
  { "TelescopeMatching", { fg = palette.bright_orange, underline = true } },
  { "TelescopeSelection", { bg = palette.dark1 } }, -- gitsigns
  { "TelescopeNormal", { fg = palette.light1, bg = palette.dark0_hard } },
  { "TelescopePromptNormal", { bg = palette.dark1 } }, -- gitsigns
  { "TelescopeResultsBorder", { fg = palette.dark0_hard, bg = palette.dark0_hard } },
  { "TelescopePreviewBorder", { fg = palette.dark0_hard, bg = palette.dark0_hard } },
  { "TelescopePromptBorder", { fg = palette.dark1, bg = palette.dark1 } },
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

  -- git
  { "GitSignsAdd", { fg = palette.bright_green, bg = "NONE" } },
  { "GitSignsChange", { fg = palette.bright_blue, bg = "NONE" } },
  { "GitSignsDelete", { fg = palette.bright_red, bg = "NONE" } },

  { "NeogitDiffAdd", { fg = palette.bright_green, bg = blend_colors(palette.bright_green, palette.dark0, 0.1) } },
  { "NeogitDiffDelete", { fg = palette.bright_red, bg = blend_colors(palette.bright_red, palette.dark0, 0.1) } },
  {
    "NeogitDiffAddHighlight",
    { fg = palette.bright_green, bg = blend_colors(palette.bright_green, palette.dark0, 0.2), bold = true },
  },
  {
    "NeogitDiffDeleteHighlight",
    { fg = palette.bright_red, bg = blend_colors(palette.bright_red, palette.dark0, 0.2), bold = true },
  },
  { "NeogitCursorLine", { bold = true, bg = palette.dark0_soft } },

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
