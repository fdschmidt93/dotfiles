utils = require('utils')

local set_keymap = vim.api.nvim_buf_set_keymap
local x = 'àa string withé fuünny charactersß'
require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
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
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  },
  extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
  }
}
require('telescope').load_extension('fzy_native')

show_lsp_diagnostics = function(opts)
  opts = opts or {}
  vim.lsp.diagnostic.set_loclist({open_loclist = false})
  require'telescope.builtin'.loclist(opts)
end


grep_visual_selection = function(opts)
  opts = opts or {}
  opts.search = utils.get_visual_selection()
  vim.api.nvim_command('normal :esc<CR>')
  -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), 'n', true) -- exit visual mode
  require'telescope.builtin'.grep_string(opts)
end


-- keymaps
vim.api.nvim_set_keymap('n', '<leader>f',   [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rs',  [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>rs',  [[<cmd>lua require('telescope.builtin').grep_string{search = require('telescope.utils').get_visual_selection()}<CR>]], { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rg',  [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>rbu',  [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>rv',    [[<cmd>lua grep_visual_selection()<CR>]], { noremap = false, silent = true })
vim.api.nvim_set_keymap('v', '<leader>vv',    [[<cmd>lua print(require'telescope.utils'.get_visual_selection())<CR>]], { noremap = false, silent = true })
vim.api.nvim_set_keymap('v', '<leader>mm',    [[<cmd>lua print(require'telescope.utils'.get_visual_pos())<CR>]], { noremap = false, silent = true })
vim.api.nvim_set_keymap('v', '<leader>uu',    [[<cmd>lua print(require'utils'.get_visual_position())<CR>]], { noremap = false, silent = true })
vim.api.nvim_set_keymap('v', '<leader>kk',    [[<cmd>lua print(require'telescope.utils'.get_visual_pos())<CR>]], { noremap = false, silent = true })
vim.api.nvim_set_keymap('n', '<leader>b',   [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>man', [[<cmd>lua require('telescope.builtin').man_pages()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>help', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qf',  [[<cmd>lua require('telescope.builtin').quickfix()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<space>d',    [[<cmd>lua show_lsp_diagnostics()<CR>]], { noremap = true, silent = true })
