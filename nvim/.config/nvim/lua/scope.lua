local status, telescope = pcall(require, 'telescope')

-- only load settings if module is available to avoid packer issues
if not status then
  return
end

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',
      '--column', '--smart-case'
    },
    prompt_position = 'bottom',
    prompt_prefix = '>',
    initial_mode = 'insert',
    selection_strategy = 'reset',
    sorting_strategy = 'descending',
    layout_strategy = 'horizontal',
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
    fzy_native = {override_generic_sorter = true, override_file_sorter = true}
  }
}
require('telescope').load_extension('fzy_native')

local find_nvim = function()
  -- agnostic to local or ssh
  local user = os.getenv('USER')
  require 'telescope.builtin'.find_files{
    prompt = 'Neovim',
    cwd = string.format('/home/%s/.config/nvim/', user)
  }
end

local k = require 'astronauta.keymap'
local nnoremap = k.nnoremap

nnoremap{'<leader>f', require'telescope.builtin'.find_files, {silent = true}}
nnoremap{'<leader>rs', require'telescope.builtin'.grep_string, {silent = true}}
nnoremap{'<leader>rg', require'telescope.builtin'.live_grep, {silent = true}}
nnoremap{'<leader>nvim', find_nvim, {silent = true}}
nnoremap{'<leader>b', require'telescope.builtin'.buffers, {silent = true}}
nnoremap{'<leader>man', require'telescope.builtin'.man_pages, {silent = true}}
nnoremap{'<leader>help', require'telescope.builtin'.help_tags, {silent = true}}
nnoremap{'<space>db', require'telescope.builtin'.lsp_document_diagnostics, {silent = true}}
nnoremap{'<space>dw', require'telescope.builtin'.lsp_workspace_diagnostics, {silent = true}}
