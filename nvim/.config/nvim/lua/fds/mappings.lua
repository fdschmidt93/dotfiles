local repl = require "fds.utils.repl"
local utils = require "fds.utils"
local opts = { silent = true }

local set = vim.keymap.set
-- general
set("i", "jk", "<ESC>", { desc = "Exitting insert mode" })
set("n", "oo", [[m`o<Esc>``]], { desc = "Insert line below" })
set("n", "OO", [[m`O<Esc>``]], { desc = "Insert line above" })

-- enter lines above/below
set("n", "Y", "y$") -- emulate other uppercase variants
set("n", [[<Leader>y]], [['+y']]) -- Copy to global clipboard with leader prefix
set("n", [[<Leader>p]], [['+p']]) -- Copp to global clipboard with leader prefix
-- emulate tmux
set("n", "<A-p>", utils.tabedit)
set("n", "<A-o>", utils.tabclose)
-- resize more intuitively by direction of arrow key
set("n", [[<A-Left>]], partial(utils.resize, true, -2))
set("n", [[<A-Right>]], partial(utils.resize, true, 2))
set("n", [[<A-Down>]], partial(utils.resize, false, 2))
set("n", [[<A-Up>]], partial(utils.resize, false, -2))
-- open terminal
set("n", [[<Leader>t]], partial(repl.shell, nil, "right"))
set("n", [[<Leader><C-t>]], partial(repl.shell, nil, "below"))
-- restart ipython terminal
set("n", [[<Leader>ti]], partial(repl.restart_term, repl.conda_env_prefix "ipython", "right"))
set("n", [[<Leader><C-t>i]], partial(repl.restart_term, repl.conda_env_prefix "ipython", "below"))
-- toggle terminal
set("n", "<A-u>", partial(repl.toggle_termwin, "right"))
set("n", "<A-i>", partial(repl.toggle_termwin, "below"))
-- misc
set("n", "<Leader><Leader>p", [[<cmd>PackerCompile<CR><cmd>PackerSync<CR>]])
set("n", "<Leader><Leader>l", [[<cmd>luafile %<CR>]])
set("n", "<Leader><Leader>swap", [[!rm ~/.local/nvim/swap/*]])
set("n", "<A-q>", require("fds.utils").write_close_all)
set("n", "<Space><Space>2", [[<cmd>:diffget 2<CR>]])
set("n", "<Space><Space>3", [[<cmd>:diffget 3<CR>]])
set("n", "<Space>todo", partial(vim.cmd, string.format("edit %s/phd/todo.md", vim.env.HOME)))
--
-- python-specific binding
set("n", "<Space><Leader>t", require("fds.utils.python").jump_to_ipy_error)

-- replace word under cursor with last yanked word
set("n", "<Leader>z", ":%s/<C-R><C-W>/<C-R>0/g<CR>")

-- Move with M from any mode
set({ "n", "i", "t" }, "<A-h>", [[<C-\><C-N><C-w>h]])
set({ "n", "i", "t" }, "<A-j>", [[<C-\><C-N><C-w>j]])
set({ "n", "i", "t" }, "<A-k>", [[<C-\><C-N><C-w>k]])
set({ "n", "i", "t" }, "<A-l>", [[<C-\><C-N><C-w>l]])

-- telescope
local ts_builtin = require "telescope.builtin"
local my_finders = require "fds.plugins.telescope.finders"
local ts_leader = "<space><space>"

set("n", ts_leader .. "f", ts_builtin.find_files, opts)
set("n", ts_leader .. "rs", ts_builtin.grep_string, opts)
-- vnoremap {
--   ts_leader .. "rg",
--   partial(ts_builtin.grep_string, { default_text = require("utils").visual_selection() }),
--   opts,
-- }

set("n", ts_leader .. "bb", ts_builtin.buffers, opts)
-- nnoremap { ts_leader .. "bf", require("telescope").extensions.file_browser.file_browser, opts }
set("n", ts_leader .. "bf", "<cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>", opts)
set("n", ts_leader .. "bi", ts_builtin.builtin, opts)
set("n", ts_leader .. "gS", ts_builtin.git_stash, opts)
set("n", ts_leader .. "gb", ts_builtin.git_branches, opts)
set("n", ts_leader .. "gc", ts_builtin.git_commits, opts)
set("n", ts_leader .. "gs", ts_builtin.git_status, opts)
set("n", ts_leader .. "help", ts_builtin.help_tags, opts)
set("n", ts_leader .. "jl", ts_builtin.jumplist, opts)
set("n", ts_leader .. "man", ts_builtin.man_pages, opts)
set("n", ts_leader .. "nf", my_finders.neorg_files, opts)
set("n", ts_leader .. "ng", my_finders.neorg_grep, opts)
set("n", ts_leader .. "pp", my_finders.papers, opts)
set("n", ts_leader .. "re", ts_builtin.resume, opts)
set("n", ts_leader .. "rb", ts_builtin.current_buffer_fuzzy_find, opts)
set("n", ts_leader .. "rg", ts_builtin.live_grep, opts)
set("n", ts_leader .. "ts", ts_builtin.treesitter, opts)
set("n", "gD", vim.lsp.buf.declaration, opts)
set("n", "gi", vim.lsp.buf.implementation, opts)
set("n", "gd", ts_builtin.lsp_definitions, opts)
set("n", "gr", ts_builtin.lsp_references, opts)
set("n", "<space>ds", ts_builtin.lsp_document_symbols, opts)
set("n", "<space>fs", partial(ts_builtin.lsp_document_symbols, { symbols = { "function", "method" } }), opts)

-- lsp
set("n", "<space>db", partial(ts_builtin.diagnostics, { prompt_title = "Document Diagnostics", bufnr = 0 }), opts)
set("n", "<space>dw", partial(ts_builtin.diagnostics, { prompt_title = "Workspace Diagnostics" }), opts)
set("n", "<space>cs", partial(ts_builtin.lsp_document_symbols, { symbols = "class" }), opts)
set("n", "<space>ws", function()
  ts_builtin.lsp_workspace_symbols { query = vim.fn.input "> " }
end, opts)
set("n", "<space>wsd", ts_builtin.lsp_dynamic_workspace_symbols, opts)

set("n", "<space>ld", vim.diagnostic.open_float, opts)
set("n", "[d", vim.diagnostic.goto_prev, opts)
set("n", "]d", vim.diagnostic.goto_next, opts)
set("n", "<space>rn", vim.lsp.buf.rename, opts)
set("n", "K", vim.lsp.buf.hover, opts)
set("n", "gs", vim.lsp.buf.signature_help, opts)
set("n", "<space>wl", function()
  P(vim.lsp.buf.list_workspace_folders())
end, opts)
set("n", "<space>D", vim.lsp.buf.type_definition, opts)
set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
set("n", "<space>f", vim.lsp.buf.formatting, opts)

-- norg
set("n", "<leader>otc", [[<cmd>Neorg gtd capture<CR>]], opts)
set("n", "<leader>otv", [[<cmd>Neorg gtd views<CR>]], opts)
set("n", "<leader>ote", [[<cmd>Neorg gtd edit<CR>]], opts)

-- luasnip
--
set("i", "<C-u>", require "luasnip.extras.select_choice")
set("i", "<c-l>", function()
  if require("luasnip").choice_active() then
    require("luasnip").change_choice(1)
  end
end)
-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
set({ "i", "s" }, "<C-k>", function()
  if require("luasnip").expand_or_jumpable() then
    require("luasnip").expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
set({ "i", "s" }, "<C-j>", function()
  if require("luasnip").expand_or_jumpable() then
    require("luasnip").jump(-1)
  end
end, { silent = true })

set("n", "<leader><leader>K", [[<cmd>source ~/.config/nvim/lua/fds/mappings.lua<CR>|<cmd>echo "sourced mappings"<CR>]])
