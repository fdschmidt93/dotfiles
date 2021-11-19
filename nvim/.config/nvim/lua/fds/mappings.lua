local repl = require "fds.utils.repl"
local utils = require "fds.utils"
local opts = { silent = true }

-- general
inoremap { "jk", [[<Esc>]] }
-- enter lines above/below
nnoremap { "oo", [[m`o<Esc>``]] }
nnoremap { "OO", [[m`O<Esc>``]] }
nnoremap { "Y", "y$" } -- emulate other uppercase variants
nnoremap { [[<Leader>y]], [['+y']] } -- Copy to global clipboard with leader prefix
nnoremap { [[<Leader>p]], [['+p']] } -- Copp to global clipboard with leader prefix
-- emulate tmux
nnoremap { "<A-p>", utils.tabedit }
nnoremap { "<A-o>", utils.tabclose }
-- resize more intuitively by direction of arrow key
nnoremap { [[<A-Left>]], partial(utils.resize, true, -2) }
nnoremap { [[<A-Right>]], partial(utils.resize, true, 2) }
nnoremap { [[<A-Down>]], partial(utils.resize, false, 2) }
nnoremap { [[<A-Up>]], partial(utils.resize, false, -2) }
-- open terminal
nnoremap { [[<Leader>t]], partial(repl.shell, nil, "right") }
nnoremap { [[<Leader><C-t>]], partial(repl.shell, nil, "below") }
-- restart ipython terminal
nnoremap { [[<Leader>ti]], partial(repl.restart_term, repl.conda_env_prefix "ipython", "right") }
nnoremap { [[<Leader><C-t>i]], partial(repl.restart_term, repl.conda_env_prefix "ipython", "below") }
-- toggle terminal
nnoremap { "<A-u>", partial(repl.toggle_termwin, "right") }
nnoremap { "<A-i>", partial(repl.toggle_termwin, "below") }
-- misc
nnoremap { "<Leader><Leader>p", [[<cmd>PackerCompile<CR><cmd>PackerSync<CR>]] }
nnoremap { "<Leader><Leader>l", [[<cmd>luafile %<CR>]] }
nnoremap { "<Leader><Leader>swap", [[!rm ~/.local/nvim/swap/*]] }
nnoremap { "<A-q>", require("fds.utils").write_close_all }
nnoremap { "<Space><Space>2", [[<cmd>:diffget 2<CR>]] }
nnoremap { "<Space><Space>3", [[<cmd>:diffget 3<CR>]] }
nnoremap { "<Space>todo", partial(vim.cmd, string.format("edit %s/phd/todo.md", vim.env.HOME)) }
--
-- python-specific binding
nnoremap { "<Space><Leader>t", require("fds.utils.python").jump_to_ipy_error }

-- replace word under cursor with last yanked word
nnoremap { "<Leader>z", ":%s/<C-R><C-W>/<C-R>0/g<CR>" }

for _, mode in ipairs { tnoremap, inoremap, nnoremap } do
  -- Move with M from any mode
  mode { "<A-h>", [[<C-\><C-N><C-w>h]] }
  mode { "<A-j>", [[<C-\><C-N><C-w>j]] }
  mode { "<A-k>", [[<C-\><C-N><C-w>k]] }
  mode { "<A-l>", [[<C-\><C-N><C-w>l]] }
end

-- telescope
local ts_builtin = require "telescope.builtin"
local my_finders = require "fds.plugins.telescope.finders"
local ts_leader = "<space><space>"

nnoremap { ts_leader .. "f", ts_builtin.find_files, opts }
nnoremap { ts_leader .. "rs", ts_builtin.grep_string, opts }
-- vnoremap {
--   ts_leader .. "rg",
--   partial(ts_builtin.grep_string, { default_text = require("utils").visual_selection() }),
--   opts,
-- }

nnoremap { ts_leader .. "bb", partial(ts_builtin.buffers, { sort_mru = true }), opts }
nnoremap { ts_leader .. "bf", require("telescope").extensions.file_browser.file_browser, opts }
nnoremap { ts_leader .. "bi", ts_builtin.builtin, opts }
nnoremap { ts_leader .. "gS", ts_builtin.git_stash, opts }
nnoremap { ts_leader .. "gb", ts_builtin.git_branches, opts }
nnoremap { ts_leader .. "gc", ts_builtin.git_commits, opts }
nnoremap { ts_leader .. "gs", ts_builtin.git_status, opts }
nnoremap { ts_leader .. "help", ts_builtin.help_tags, opts }
nnoremap { ts_leader .. "jl", ts_builtin.jumplist, opts }
nnoremap { ts_leader .. "man", ts_builtin.man_pages, opts }
nnoremap { ts_leader .. "nf", my_finders.neorg_files, opts }
nnoremap { ts_leader .. "ng", my_finders.neorg_grep, opts }
nnoremap { ts_leader .. "pp", my_finders.papers, opts }
nnoremap { ts_leader .. "re", ts_builtin.resume, opts }
nnoremap { ts_leader .. "rr", require("telescope").extensions.live_grep_raw.live_grep_raw, opts }
nnoremap { ts_leader .. "rb", ts_builtin.current_buffer_fuzzy_find, opts }
nnoremap { ts_leader .. "rg", ts_builtin.live_grep, opts }
nnoremap { "gD", vim.lsp.buf.declaration, opts }
nnoremap { "gi", vim.lsp.buf.implementation, opts }
nnoremap { "gd", ts_builtin.lsp_definitions, opts }
nnoremap { "gr", ts_builtin.lsp_references, opts }
nnoremap { "<space>ds", ts_builtin.lsp_document_symbols, opts }
vnoremap { "<space>ds", ts_builtin.lsp_document_symbols, opts }
nnoremap {
  "<space>fs",
  partial(ts_builtin.lsp_document_symbols, { symbols = { "function", "method" } }),
  opts,
}

-- lsp
nnoremap { "<space>db", ts_builtin.lsp_document_diagnostics, opts }
nnoremap { "<space>dw", ts_builtin.lsp_workspace_diagnostics, opts }
nnoremap { "<space>cs", partial(ts_builtin.lsp_document_symbols, { symbols = "class" }), opts }
nnoremap {
  "<space>ws",
  function()
    ts_builtin.lsp_workspace_symbols { query = vim.fn.input "> " }
  end,
  opts,
}
nnoremap { "<space>wsd", ts_builtin.lsp_dynamic_workspace_symbols, opts }

nnoremap {
  "<space>ld",
  function()
    vim.lsp.diagnostic.show_line_diagnostics { border = "solid" }
  end,
  opts,
}
nnoremap { "[d", vim.lsp.diagnostic.goto_prev, opts }
nnoremap { "]d", vim.lsp.diagnostic.goto_next, opts }
nnoremap { "<space>rn", require("renamer").rename, opts }
nnoremap { "K", vim.lsp.buf.hover, opts }
nnoremap { "gs", vim.lsp.buf.signature_help, opts }
nnoremap {
  "<space>wl",
  function()
    P(vim.lsp.buf.list_workspace_folders())
  end,
  opts,
}
nnoremap { "<space>D", vim.lsp.buf.type_definition, opts }
nnoremap { "<space>wa", vim.lsp.buf.add_workspace_folder, opts }
nnoremap { "<space>wr", vim.lsp.buf.remove_workspace_folder, opts }
nnoremap { "<space>f", vim.lsp.buf.formatting, opts }

-- norg
nnoremap { "<leader>otc", [[<cmd>Neorg gtd capture<CR>]], opts }
nnoremap { "<leader>otv", [[<cmd>Neorg gtd views<CR>]], opts }
nnoremap { "<leader>ote", [[<cmd>Neorg gtd edit<CR>]], opts }
