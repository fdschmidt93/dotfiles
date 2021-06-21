local utils = require "utils"

inoremap { "jk", [[<Esc>]] } -- Go to normal mode with jk
nnoremap { "oo", [[m`o<Esc>``]] }
nnoremap { "OO", [[m`O<Esc>``]] }

nnoremap { [[<Leader>y]], [['+y']] } -- Copy to global clipboard with leader prefix
nnoremap { [[<Leader>p]], [['+p']] } -- Copp to global clipboard with leader prefix
nnoremap { "Y", "y$" }
--

local repl = require "utils.repl"
-- resize splits with arrow keys
nnoremap {
  [[<A-Left>]],
  function()
    utils.resize(true, -2)
  end,
}
nnoremap {
  [[<A-Right>]],
  function()
    utils.resize(true, -7)
  end,
}
nnoremap {
  [[<A-Up>]],
  function()
    utils.resize(false, -2)
  end,
}
nnoremap {
  [[<A-Down>]],
  function()
    utils.resize(false, 2)
  end,
}
nnoremap {
  [[<Leader>t]],
  function()
    repl.shell("right", nil)
  end,
}
nnoremap {
  [[<Leader>ti]],
  function()
    repl.re_start_ipython("right", "ipython")
  end,
}
nnoremap {
  [[<Leader><C-t>]],
  function()
    repl.shell("below", nil)
  end,
}
nnoremap {
  [[<Leader><C-t>i]],
  function()
    repl.re_start_ipython("below", "ipython")
  end,
}
nnoremap { [[<Leader>q]], ":q!<CR>" }

for _, mode in pairs { tnoremap, inoremap, nnoremap } do
  mode { "<A-h>", [[<C-\><C-N><C-w>h]] } -- Move with M from any mode
  mode { "<A-j>", [[<C-\><C-N><C-w>j]] }
  mode { "<A-k>", [[<C-\><C-N><C-w>k]] }
  mode { "<A-l>", [[<C-\><C-N><C-w>l]] }
end

nnoremap { "<A-p>", R("utils").tabedit }
nnoremap { "<A-o>", R("utils").tabclose }

nnoremap { "<Space><Leader>t", R("utils.python").jump_to_ipy_error }

nnoremap { "<Leader><Leader>p", [[<cmd>PackerCompile<CR><cmd>PackerSync<CR>]] }
nnoremap { "<Leader><Leader>l", [[<cmd>luafile %<CR>]] }

-- vim.api.nvim_set_keymap('v', [[<Leader>vv]], [[<cmd>lua R('utils').visual_selection()<CR>]], {noremap = true})

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
