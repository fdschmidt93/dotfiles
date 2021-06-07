local status, telescope = pcall(require, 'telescope')

-- telescope.setup {
--   defaults = {
--     vimgrep_arguments = {
--       'rg', '--color=never', '--no-heading', '--with-filename', '--line-number',
--       '--column', '--smart-case'
--     },
--     prompt_position = 'bottom',
--     prompt_prefix = '> ',
--     initial_mode = 'insert',
--     selection_strategy = 'reset',
--     sorting_strategy = 'descending',
--     layout_strategy = 'horizontal',
--     layout_defaults = {
--       -- TODO add builtin options.
--     },
--     file_ignore_patterns = {},
--     shorten_path = true,
--     winblend = 0,
--     width = 0.75,
--     preview_cutoff = 120,
--     results_height = 1,
--     results_width = 0.5,
--     border = {},
--     borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
--     color_devicons = true,
--     use_less = true,
--     set_env = {['COLORTERM'] = 'truecolor'}, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
--     file_previewer = require'telescope.previewers'.vim_buffer_cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
--     grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
--     qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`

--     -- Developer configurations: Not meant for general override
--     buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
--   },
--   extensions = {
--     fzf = {
--       fuzzy = true,
--       override_generic_sorter = true,
--       override_file_sorter = true,
--       case_mode = 'smart_case'
--     }
--   }
-- }
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
telescope.load_extension('fzf')
telescope.load_extension('project')

-- -- local dropdown_opts = R('telescope.themes').get_dropdown {
-- --   border = true,
-- --   previewer = false,
-- --   shorten_path = false,
-- --   prompt_prefix = "> "
-- -- }

-- -- local find_nvim = function()
-- --   -- agnostic to local or ssh
-- --   local user = os.getenv('USER')
-- --   local opts = vim.deepcopy(dropdown_opts)
-- --   opts.prompt = 'Neovim'
-- --   opts.cwd = string.format('/home/%s/.config/nvim/', user)
-- --   R('telescope.builtin').find_files(opts)
-- -- end

-- -- local find_notes = function()
-- --   local user = os.getenv('USER')
-- --   R('telescope.builtin').find_files {
-- --     prompt = 'Neovim',
-- --     cwd = string.format('/home/%s/notes/', user)
-- --   }
-- -- end

-- -- local find_meetings = function()
-- --   local user = os.getenv('USER')
-- --   R('telescope.builtin').find_files {
-- --     prompt = 'Neovim',
-- --     cwd = string.format('/home/%s/phd/meetings', user)
-- --   }
-- -- end

-- -- function curbuf() R('telescope.builtin').current_buffer_fuzzy_find(opts) end

-- -- mappings

local opt = {silent = true}
nnoremap {'<space><space>f', R('telescope.builtin').find_files, opt}
nnoremap {'<space><space>rs', R('telescope.builtin').grep_string, opt}
vnoremap {'<space><space>rs', function() R('telescope.builtin').grep_string{query=require('utils').visual_selection()} end, opt}
nnoremap {'<space><space>rg', R('telescope.builtin').live_grep, opt}
nnoremap {'<space><space>man', R('telescope.builtin').man_pages, opt}
nnoremap {'<space><space>help', R('telescope.builtin').help_tags, opt}
nnoremap {'<leader><leader>t', R('telescope.builtin').builtin, opt}
-- -- nnoremap {'<space><space>b', curbuf, opt}
-- -- nnoremap {'<space><space>nvim', find_nvim, opt}
-- -- nnoremap {'<leader><leader>n', find_notes, opt}
