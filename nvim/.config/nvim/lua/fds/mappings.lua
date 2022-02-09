local repl = require "fds.utils.repl"
local utils = require "fds.utils"
local opts = { silent = true }

local map = function(args)
  vim.keymap.set(args.mode, args.lhs, args.rhs, args.opts)
end

-- general
map { mode = "i", lhs = "jk", rhs = "<ESC>", opts = { desc = "Exitting insert mode" } }
map { mode = "n", lhs = "oo", rhs = [[m`o<Esc>``]], opts = { desc = "Insert line below" } }
map { mode = "n", lhs = "OO", rhs = [[m`O<Esc>``]], opts = { desc = "Insert line above" } }

-- enter lines above/below
map { mode = "n", lhs = "Y", rhs = "y$" } -- emulate other uppercase variants
map { mode = "n", lhs = [[<Leader>y]], rhs = [['+y']] } -- Copy to global clipboard with leader prefix
map { mode = "n", lhs = [[<Leader>p]], rhs = [['+p']] } -- Copp to global clipboard with leader prefix
-- emulate tmux
map { mode = "n", lhs = "<A-p>", rhs = utils.tabedit }
map { mode = "n", lhs = "<A-o>", rhs = utils.tabclose }
-- resize more intuitively by direction of arrow key
map { mode = "n", lhs = [[<A-Left>]], rhs = partial(utils.resize, true, -2) }
map { mode = "n", lhs = [[<A-Right>]], rhs = partial(utils.resize, true, 2) }
map { mode = "n", lhs = [[<A-Down>]], rhs = partial(utils.resize, false, 2) }
map { mode = "n", lhs = [[<A-Up>]], rhs = partial(utils.resize, false, -2) }
-- open terminal
map { mode = "n", lhs = [[<Leader>t]], rhs = partial(repl.shell, nil, "right") }
map { mode = "n", lhs = [[<Leader><C-t>]], rhs = partial(repl.shell, nil, "below") }
-- restart ipython terminal
map { mode = "n", lhs = [[<Leader>ti]], rhs = partial(repl.restart_term, repl.conda_env_prefix "ipython", "right") }
map { mode = "n", lhs = [[<Leader><C-t>i]], rhs = partial(repl.restart_term, repl.conda_env_prefix "ipython", "below") }
-- toggle terminal
map { mode = "n", lhs = "<A-u>", rhs = partial(repl.toggle_termwin, "right") }
map { mode = "n", lhs = "<A-i>", rhs = partial(repl.toggle_termwin, "below") }
-- misc
map { mode = "n", lhs = "<Leader><Leader>p", rhs = [[<cmd>PackerCompile<CR><cmd>PackerSync<CR>]] }
map { mode = "n", lhs = "<Leader><Leader>l", rhs = [[<cmd>luafile %<CR>]] }
map { mode = "n", lhs = "<Leader><Leader>swap", rhs = [[!rm ~/.local/nvim/swap/*]] }
map { mode = "n", lhs = "<A-q>", rhs = require("fds.utils").write_close_all }
map { mode = "n", lhs = "<Space><Space>2", rhs = [[<cmd>:diffget 2<CR>]] }
map { mode = "n", lhs = "<Space><Space>3", rhs = [[<cmd>:diffget 3<CR>]] }
map { mode = "n", lhs = "<Space>todo", rhs = partial(vim.cmd, string.format("edit %s/phd/todo.md", vim.env.HOME)) }
--
-- python-specific binding
map { mode = "n", lhs = "<Space><Leader>t", rhs = require("fds.utils.python").jump_to_ipy_error }

-- replace word under cursor with last yanked word
map { mode = "n", lhs = "<Leader>z", rhs = ":%s/<C-R><C-W>/<C-R>0/g<CR>" }

-- Move with M from any mode
map { mode = { "n", "i", "t" }, lhs = "<A-h>", rhs = [[<C-\><C-N><C-w>h]] }
map { mode = { "n", "i", "t" }, lhs = "<A-j>", rhs = [[<C-\><C-N><C-w>j]] }
map { mode = { "n", "i", "t" }, lhs = "<A-k>", rhs = [[<C-\><C-N><C-w>k]] }
map { mode = { "n", "i", "t" }, lhs = "<A-l>", rhs = [[<C-\><C-N><C-w>l]] }

-- telescope
local ts_builtin = require "telescope.builtin"
local my_finders = require "fds.plugins.telescope.finders"
local ts_leader = "<space><space>"

map { mode = "n", lhs = ts_leader .. "f", rhs = ts_builtin.find_files, opts = opts }
map { mode = "n", lhs = ts_leader .. "rs", rhs = ts_builtin.grep_string, opts = opts }
-- vnoremap {
--   ts_leader .. "rg",
--   partial(ts_builtin.grep_string, { default_text = require("utils").visual_selection() }),
--    opts = opts,
-- }

map { mode = "n", lhs = ts_leader .. "bb", rhs = ts_builtin.buffers, opts = opts }
-- nnoremap { ts_leader .. "bf", require("telescope").extensions.file_browser.file_browser,  opts = opts }
map {
  mode = "n",
  lhs = ts_leader .. "bf",
  rhs = "<cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>",
  opts = opts,
}
map { mode = "n", lhs = ts_leader .. "bi", rhs = ts_builtin.builtin, opts = opts }
map { mode = "n", lhs = ts_leader .. "gS", rhs = ts_builtin.git_stash, opts = opts }
map { mode = "n", lhs = ts_leader .. "gb", rhs = ts_builtin.git_branches, opts = opts }
map { mode = "n", lhs = ts_leader .. "gc", rhs = ts_builtin.git_commits, opts = opts }
map { mode = "n", lhs = ts_leader .. "gs", rhs = ts_builtin.git_status, opts = opts }
map { mode = "n", lhs = ts_leader .. "help", rhs = ts_builtin.help_tags, opts = opts }
map { mode = "n", lhs = ts_leader .. "jl", rhs = ts_builtin.jumplist, opts = opts }
map { mode = "n", lhs = ts_leader .. "man", rhs = ts_builtin.man_pages, opts = opts }
map { mode = "n", lhs = ts_leader .. "nf", rhs = my_finders.neorg_files, opts = opts }
map { mode = "n", lhs = ts_leader .. "ng", rhs = my_finders.neorg_grep, opts = opts }
map { mode = "n", lhs = ts_leader .. "pp", rhs = my_finders.papers, opts = opts }
map { mode = "n", lhs = ts_leader .. "re", rhs = ts_builtin.resume, opts = opts }
map {
  mode = "n",
  lhs = ts_leader .. "rr",
  rhs = require("telescope").extensions.live_grep_raw.live_grep_raw,
  opts = opts,
}
map { mode = "n", lhs = ts_leader .. "rb", rhs = ts_builtin.current_buffer_fuzzy_find, opts = opts }
map { mode = "n", lhs = ts_leader .. "rg", rhs = ts_builtin.live_grep, opts = opts }
map { mode = "n", lhs = ts_leader .. "ts", rhs = ts_builtin.treesitter, opts = opts }
map { mode = "n", lhs = "gD", rhs = vim.lsp.buf.declaration, opts = opts }
map { mode = "n", lhs = "gi", rhs = vim.lsp.buf.implementation, opts = opts }
map { mode = "n", lhs = "gd", rhs = ts_builtin.lsp_definitions, opts = opts }
map { mode = "n", lhs = "gr", rhs = ts_builtin.lsp_references, opts = opts }
map { mode = "n", lhs = "<space>ds", rhs = ts_builtin.lsp_document_symbols, opts = opts }
map {
  mode = "n",
  lhs = "<space>fs",
  rhs = partial(ts_builtin.lsp_document_symbols, { symbols = { "function", "method" } }),
  opts = opts,
}

-- lsp
map {
  mode = "n",
  lhs = "<space>db",
  rhs = partial(ts_builtin.diagnostics, { prompt_title = "Document Diagnostics", bufnr = 0 }),
  opts = opts,
}
map {
  mode = "n",
  lhs = "<space>dw",
  rhs = partial(ts_builtin.diagnostics, { prompt_title = "Workspace Diagnostics" }),
  opts = opts,
}
map {
  mode = "n",
  lhs = "<space>cs",
  rhs = partial(ts_builtin.lsp_document_symbols, { symbols = "class" }),
  opts = opts,
}
map {
  mode = "n",
  lhs = "<space>ws",
  rhs = function()
    ts_builtin.lsp_workspace_symbols { query = vim.fn.input "> " }
  end,
  opts = opts,
}
map { mode = "n", lhs = "<space>wsd", rhs = ts_builtin.lsp_dynamic_workspace_symbols, opts = opts }

map {
  mode = "n",
  lhs = "<space>ld",
  rhs = vim.diagnostic.open_float,
  opts = opts,
}
map { mode = "n", lhs = "[d", rhs = vim.diagnostic.goto_prev, opts = opts }
map { mode = "n", lhs = "]d", rhs = vim.diagnostic.goto_next, opts = opts }
map { mode = "n", lhs = "<space>rn", rhs = require("renamer").rename, opts = opts }
map { mode = "n", lhs = "K", rhs = vim.lsp.buf.hover, opts = opts }
map { mode = "n", lhs = "gs", rhs = vim.lsp.buf.signature_help, opts = opts }
map {
  mode = "n",
  lhs = "<space>wl",
  rhs = function()
    P(vim.lsp.buf.list_workspace_folders())
  end,
  opts = opts,
}
map { mode = "n", lhs = "<space>D", rhs = vim.lsp.buf.type_definition, opts = opts }
map { mode = "n", lhs = "<space>wa", rhs = vim.lsp.buf.add_workspace_folder, opts = opts }
map { mode = "n", lhs = "<space>wr", rhs = vim.lsp.buf.remove_workspace_folder, opts = opts }
map { mode = "n", lhs = "<space>f", rhs = vim.lsp.buf.formatting, opts = opts }

-- norg
map { mode = "n", lhs = "<leader>otc", rhs = [[<cmd>Neorg gtd capture<CR>]], opts = opts }
map { mode = "n", lhs = "<leader>otv", rhs = [[<cmd>Neorg gtd views<CR>]], opts = opts }
map { mode = "n", lhs = "<leader>ote", rhs = [[<cmd>Neorg gtd edit<CR>]], opts = opts }
