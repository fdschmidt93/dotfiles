local utils = require "utils"

inoremap { "jk", [[<Esc>]] }

local repl = require "utils.repl"

-- normal mode mappings
vim.tbl_map(nnoremap, {
  -- enter lines above/below
  { "oo", [[m`o<Esc>``]] },
  { "OO", [[m`O<Esc>``]] },
  { "Y", "y$" }, -- emulate other uppercase variants
  { [[<Leader>y]], [['+y']] }, -- Copy to global clipboard with leader prefix
  { [[<Leader>p]], [['+p']] }, -- Copp to global clipboard with leader prefix
  -- emulate tmux
  { "<A-p>", require("utils").tabedit },
  { "<A-o>", require("utils").tabclose },
  -- resize more intuitively by direction of arrow key
  { [[<A-Left>]], [[<C-W>> 2]]},
  { [[<A-Right>]], [[<C-W>< 2]]},
  { [[<A-Up>]], [[<C-W>+ 2]]},
  { [[<A-Down>]], [[<C-W>- 2]]},
  -- open terminal
  { [[<Leader>t]], partial(repl.shell, nil, "right") },
  { [[<Leader><C-t>]], partial(repl.shell, nil, "below") },
  -- restart ipython terminal
  { [[<Leader>ti]], partial(repl.restart_term, repl.conda_env_prefix "ipython", "right") },
  { [[<Leader><C-t>i]], partial(repl.restart_term, repl.conda_env_prefix "ipython", "below") },
  -- toggle terminal
  { "<A-u>", partial(repl.toggle_termwin, "right") },
  { "<A-i>", partial(repl.toggle_termwin, "below") },
  -- python-specific binding
  { "<Space><Leader>t", require("utils.python").jump_to_ipy_error },
  -- misc
  { "<Leader><Leader>p", [[<cmd>PackerCompile<CR><cmd>PackerSync<CR>]] },
  { "<Leader><Leader>l", [[<cmd>luafile %<CR>]] },
  { "<Leader><Leader>swap", [[!rm ~/.local/nvim/swap/*]] },
  { "<A-q>", require("utils").write_close_all },
})

for _, mode in ipairs { tnoremap, inoremap, nnoremap } do
  -- Move with M from any mode
  mode { "<A-h>", [[<C-\><C-N><C-w>h]] }
  mode { "<A-j>", [[<C-\><C-N><C-w>j]] }
  mode { "<A-k>", [[<C-\><C-N><C-w>k]] }
  mode { "<A-l>", [[<C-\><C-N><C-w>l]] }
end

-- TODO replace when keymaps support expr
vim.api.nvim_set_keymap(
  "i",
  [[<C-Space>]],
  [[compe#complete()]],
  { silent = true, noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
  "i",
  [[<CR>]],
  [[compe#confirm('<CR>')]],
  { silent = true, noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
  "i",
  [[<C-e>]],
  [[compe#close('<C-e>')]],
  { silent = true, noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
  "i",
  [[<C-f>]],
  [[compe#scroll({ 'delta': -4})]],
  { silent = true, noremap = true, expr = true }
)
vim.api.nvim_set_keymap(
  "i",
  [[<C-d>]],
  [[compe#scroll({ 'delta': +4})]],
  { silent = true, noremap = true, expr = true }
)

