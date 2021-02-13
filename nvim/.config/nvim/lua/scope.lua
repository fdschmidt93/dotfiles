require('telescope').setup {
  defaults = {
    vimgrep_arguments = {
      'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',
      '--column', '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = ">",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      -- TODO add builtin options.
    },
    file_sorter = require'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = {},
    generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    color_devicons = true,
    use_less = true,
    set_env = {['COLORTERM'] = 'truecolor'}, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  },
  extensions = {
    fzy_native = {override_generic_sorter = false, override_file_sorter = true}
  }
}
require('telescope').load_extension('fzy_native')

local k = require "astronauta.keymap"
local nnoremap = k.nnoremap

nnoremap{'<leader>f', require'telescope.builtin'.find_files, {silent = true}}
nnoremap{'<leader>rs', require'telescope.builtin'.grep_string, {silent = true}}
-- nnoremap{'<leader>rs', require'telescope.builtin'.grep_string{search = require('telescope.utils').get_visual_selection()}<CR>]], {noremap = false, silent = true})
nnoremap{'<leader>rg', require'telescope.builtin'.live_grep, {silent = true}}
-- nnoremap{'<leader>rbu', [[<cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>]], {noremap = true, silent = true}}
-- nnoremap{'<leader>rv', [[<cmd>lua grep_visual_selection()<CR>]], {noremap = false, silent = true})
-- nnoremap{'<leader>vv', [[<cmd>lua print(require'telescope.utils'.get_visual_selection())<CR>]], {noremap = false, silent = true})
-- nnoremap{'<leader>mm', [[<cmd>lua print(require'telescope.utils'.get_visual_pos())<CR>]], {noremap = false, silent = true})
-- nnoremap{'<leader>uu', [[<cmd>lua print(require'utils'.get_visual_position())<CR>]], {noremap = false, silent = true})
-- nnoremap{'<leader>kk', [[<cmd>lua print(require'telescope.utils'.get_visual_pos())<CR>]], {noremap = false, silent = true})
nnoremap{'<leader>b', require'telescope.builtin'.buffers, {silent = true}}
nnoremap{'<leader>man', require'telescope.builtin'.man_pages, {silent = true}}
nnoremap{'<leader>help', require'telescope.builtin'.help_tags, {silent = true}}
nnoremap{'<leader>qf', require'telescope.builtin'.quickfix, {silent = true}}
nnoremap{'<space>d', require'telescope.builtin'.lsp_diagnostics, {silent = true}}
