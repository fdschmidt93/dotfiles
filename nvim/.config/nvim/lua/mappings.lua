local utils = require 'utils'

local k = require 'astronauta.keymap'

local nnoremap = k.nnoremap
local inoremap = k.inoremap
local tnoremap = k.tnoremap
local vnoremap = k.vnoremap

inoremap {'jk', [[<Esc>]]} -- Go to normal mode with jk
nnoremap {'oo', [[m`o<Esc>``]]}
nnoremap {'OO', [[m`O<Esc>``]]}

nnoremap {[[<Leader>y]], [['+y']]} -- Copy to global clipboard with leader prefix
nnoremap {[[<Leader>p]], [['+p']]} -- Copp to global clipboard with leader prefix
nnoremap {'Y', 'y$'}
-- toggle qf window
nnoremap {'<C-q>', utils.toggle_qf, {silent = true}}

local repl = require 'repl'
-- resize splits with arrow keys
-- nnoremap {[[<A-Left>]], ':vertical resize -2<CR>'}
-- nnoremap {[[<A-Right>]], ':vertical resize -2<CR>'}
nnoremap {[[<A-Left>]], function() utils.resize(true, -2) end}
nnoremap {[[<A-Right>]], function() utils.resize(true, 2) end}
nnoremap {[[<A-Up>]], function() utils.resize(false, -2) end}
nnoremap {[[<A-Down>]], function() utils.resize(false, 2) end}
-- nnoremap {[[<A-Up>]], ':resize +2<CR>'}
-- nnoremap {[[<C-S-Down>]], ':resize -2<CR>'}
nnoremap {[[<Leader>t]], function() repl.shell('right', nil) end}
nnoremap {[[<Leader>ti]], function() repl.shell('right', 'ipython') end}
nnoremap {[[<Leader><C-t>]], function() repl.shell('below', nil) end}
nnoremap {[[<Leader><C-t>i]], function() repl.shell('below', 'ipython') end}
nnoremap {[[<Leader>q]], ':q!<CR>'}

tnoremap {'<A-h>', [[<C-\><C-N><C-w>h]]} -- Move with M from any mode
tnoremap {'<A-j>', [[<C-\><C-N><C-w>j]]}
tnoremap {'<A-k>', [[<C-\><C-N><C-w>k]]}
tnoremap {'<A-l>', [[<C-\><C-N><C-w>l]]}
inoremap {'<A-h>', [[<C-\><C-N><C-w>h]]}
inoremap {'<A-j>', [[<C-\><C-N><C-w>j]]}
inoremap {'<A-k>', [[<C-\><C-N><C-w>k]]}
inoremap {'<A-l>', [[<C-\><C-N><C-w>l]]}
nnoremap {'<A-h>', [[<C-w>h]]}
nnoremap {'<A-j>', [[<C-w>j]]}
nnoremap {'<A-k>', [[<C-w>k]]}
nnoremap {'<A-l>', [[<C-w>l]]}

nnoremap {'<Leader><Leader>p', [[<cmd>PackerCompile<CR><cmd>PackerSync<CR>]]}
nnoremap {'<Leader><Leader>l', [[<cmd>luafile %<CR>]]}


vim.api.nvim_set_keymap('v', [[<Leader>vv]], [[<cmd>lua R('utils').visual_selection()<CR>]], {noremap = true})


-- TODO replace when keymaps support expr
vim.api.nvim_set_keymap('i', [[<C-Space>]], [[compe#complete()]],
                        {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('i', [[<CR>]], [[compe#confirm('<CR>')]],
                        {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('i', [[<C-e>]], [[compe#close('<C-e>')]],
                        {silent = true, noremap = true, expr = true})
