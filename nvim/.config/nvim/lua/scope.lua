if not loaded('telescope.nvim') then return end

local telescope = require 'telescope'

telescope.setup {
  defaults = {
    vimgrep_arguments = {
      'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',
      '--column', '--smart-case'
    },
    prompt_position = 'bottom',
    prompt_prefix = '>', initial_mode = 'insert', selection_strategy = 'reset', sorting_strategy = 'descending',
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
    results_width = 0.5,
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
telescope.load_extension('fzy_native')

local k = require 'astronauta.keymap'
local nnoremap = k.nnoremap
local builtin = require 'telescope.builtin'

local find_nvim = function()
  -- agnostic to local or ssh
  local user = os.getenv('USER')
  builtin.find_files {
    prompt = 'Neovim',
    cwd = string.format('/home/%s/.config/nvim/', user)
  }
end

local opt = {silent = true}
nnoremap {'<leader>f', builtin.find_files, opt}
nnoremap {'<leader>rs', builtin.grep_string, opt}
nnoremap {'<leader>rg', builtin.live_grep, opt}
nnoremap {'<leader>b', builtin.buffers, opt}
nnoremap {'<leader>nvim', find_nvim, opt}
nnoremap {'<leader>man', builtin.man_pages, opt}
nnoremap {'<leader>help', builtin.help_tags, opt}
nnoremap {'<leader>help', builtin.help_tags, opt}
nnoremap {'<leader><leader>t', builtin.builtin, opt}
