local repl = require "fds.utils.repl"
local utils = require "fds.utils"
local opts = { silent = true }
local set = vim.keymap.set

-- general
set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
set("n", "oo", [[m`o<Esc>``]], { desc = "Insert line below" })
set("n", "OO", [[m`O<Esc>``]], { desc = "Insert line above" })

set("n", [[<Leader>y]], [['+y']], { desc = "Yank to global register" }) -- Copy to global clipboard with leader prefix
set("n", [[<Leader>p]], [['+p']], { desc = "Paste from global register" }) -- Copp to global clipboard with leader prefix
-- emulate tmux
set("n", "<A-p>", utils.tabedit)
set("n", "<A-o>", utils.tabclose)
-- resize more intuitively by direction of arrow key
set("n", [[<A-Left>]], partial(utils.resize, true, -2))
set("n", [[<A-Right>]], partial(utils.resize, true, 2))
set("n", [[<A-Down>]], partial(utils.resize, false, 2))
set("n", [[<A-Up>]], partial(utils.resize, false, -2))
-- open terminal
set("n", [[<Leader>t]], function()
  repl.shell { side = "right" }
end, { desc = "Terminal: open to right" })
set("n", [[<Leader><C-t>]], function()
  repl.shell { side = "below" }
end, { desc = "Terminal: open below" })

set("n", [[<Leader>ti]], function()
  repl.restart_term(repl.wrap_conda_env "ipython", { side = "right" })
end, { desc = "Terminal: (re-)start ipython to right" })
set("n", [[<Leader><C-t>i]], function()
  repl.restart_term(repl.wrap_conda_env "ipython", { side = "below" })
end, { desc = "Terminal: (re-)start ipython below" })
-- toggle terminal
set("n", "<A-u>", partial(repl.toggle_termwin, "right"), { desc = "Terminal: toggle right" })
set("n", "<A-i>", partial(repl.toggle_termwin, "below"), { desc = "Terminal: toggle below" })
-- misc
set("n", "<Leader><Leader>l", [[<cmd>luafile %<CR>]], { desc = "Lua: run current file" })
set("n", "<Leader><Leader>swap", [[!rm ~/.local/nvim/swap/*]], { desc = "Clear swap" })
set("n", "<A-q>", require("fds.utils").write_close_all, { desc = "Save and close buffers" })
set("n", "<Space><Space>2", [[<cmd>:diffget //2<CR>]])
set("n", "<Space><Space>3", [[<cmd>:diffget //3<CR>]])

-- replace word under cursor with last yanked word
set("n", "<Leader>z", ":%s/<C-R><C-W>/<C-R>0/g<CR>")

-- Move with M from any mode
set({ "n", "i", "t" }, "<A-h>", [[<C-\><C-N><C-w>h]])
set({ "n", "i", "t" }, "<A-j>", [[<C-\><C-N><C-w>j]])
set({ "n", "i", "t" }, "<A-k>", [[<C-\><C-N><C-w>k]])
set({ "n", "i", "t" }, "<A-l>", [[<C-\><C-N><C-w>l]])

-- telescope
local ts = setmetatable({}, {
  __index = function(_, key)
    return function(topts)
      local mode = vim.api.nvim_get_mode().mode
      topts = topts or {}
      if mode == "v" or mode == "V" or mode == "" then
        topts.default_text = table.concat(require("fds.utils").get_selection())
      end
      if key == "grep" then
        require("telescope").extensions.egrepify.egrepify(topts)
      elseif key == "find_files" then
        require("telescope").extensions.corrode.corrode(topts)
      else
        local builtin = require "telescope.builtin"
        builtin[key](topts)
      end
    end
  end,
})
-- local my_finders = require "fds.plugins.telescope.finders"
local ts_leader = "<space><space>"

set("n", ts_leader .. "f", ts.find_files, { silent = true, desc = "Telescope: Find Files" })
set("n", "<M-x>", ts.commands, { silent = true, desc = "Telescope: Commands" })
set("i", "<C-f>", ts.find_files, { silent = true, desc = "Telescope: Find Files" })
set("i", "<C-s>", ts.symbols, { silent = true, desc = "Telescope: Symbols" })
set("n", ts_leader .. "rs", ts.grep_string, { silent = true, desc = "Telescope: Grep String" })
set("v", ts_leader .. "rs", ts.grep_string, { silent = true, desc = "Telescope: Grep String" })
set("n", ts_leader .. "bb", ts.buffers, { silent = true, desc = "Telescope: Buffers" })
-- nnoremap { ts_leader .. "bf", require("telescope").extensions.file_browser.file_browser, {silent = true, } }
set("n", ts_leader .. "bf", function()
  require("telescope").extensions.file_browser.file_browser()
end, { silent = true, desc = "Telescope: File Browser" })
set("n", ts_leader .. "bF", function()
  require("telescope").extensions.file_browser.file_browser { path = "%:p:h", select_buffer = true }
end, { silent = true, desc = "Telescope: File Browser (current buffer)" })
set("n", ts_leader .. "bi", ts.builtin, { silent = true, desc = "Telescope: Builtins" })
set("n", ts_leader .. "gS", ts.git_stash, { silent = true, desc = "Telescope: Git Stash" })
set("n", ts_leader .. "gb", ts.git_branches, { silent = true, desc = "Telescope: Git Branches" })
set("n", ts_leader .. "gc", ts.git_commits, { silent = true, desc = "Telescope: Git Commits" })
set("n", ts_leader .. "gs", ts.git_status, { silent = true, desc = "Telescope: Git Status" })
set("n", ts_leader .. "help", ts.help_tags, { silent = true, desc = "Telescope: Help Tags" })
set("n", ts_leader .. "jl", ts.jumplist, { silent = true, desc = "Telescope: Jumplist " })
set("n", ts_leader .. "man", ts.man_pages, { silent = true, desc = "Telescope: Man Pages " })
set("n", ts_leader .. "re", ts.resume, { silent = true, desc = "Telescope: Resume " })
set(
  "n",
  ts_leader .. "rb",
  ts.current_buffer_fuzzy_find,
  { silent = true, desc = "Telescope: Current Buffer Fuzzy Find " }
)
set("n", ts_leader .. "rg", ts.grep, { silent = true, desc = "Telescope: Live Grep " })
set("n", ts_leader .. "RG", function()
  ts.grep { grep_open_files = true }
end, { silent = true, desc = "Telescope: Live Grep " })
set("n", ts_leader .. "rG", function()
  ts.grep { default_text = vim.fn.expand "<cword>" }
end, { silent = true, desc = "Telescope: Live Grep (cword)" })
set("v", ts_leader .. "rg", function()
  ts.grep { default_text = table.concat(require("fds.utils").get_selection(), "") }
end, { silent = true, desc = "Telescope: Live Grep (visual selection)" })
set("n", ts_leader .. "ts", ts.treesitter, { silent = true, desc = "Telescope: Treesitter" })
set("n", "<space>", vim.lsp.buf.code_action, { silent = true, desc = "LSP Code Action" })
set("n", "gD", vim.lsp.buf.declaration, { silent = true, desc = "Telescope: LSP Declaration" })
set("n", "gi", vim.lsp.buf.implementation, { silent = true, desc = "Telescope: LSP Implementation" })
set("n", "gd", ts.lsp_definitions, { silent = true, desc = "Telescope: LSP Definitions" })
set("n", "gr", ts.lsp_references, { silent = true, desc = "Telescope: LSP References" })
set("n", "<space>ds", ts.lsp_document_symbols, { silent = true, desc = "Telescope: LSP Document Symbols" })
set("v", "<space>x", R("fds.utils").get_selection)
set(
  "n",
  "<space>fs",
  partial(ts.lsp_document_symbols, { symbols = { "function", "method" } }),
  { silent = true, desc = "Telescope: LSP Function Symbols" }
)

-- lsp
set(
  "n",
  "<space>db",
  partial(ts.diagnostics, { prompt_title = "Document Diagnostics", bufnr = 0 }),
  { silent = true, desc = "Telescope: LSP Document Diagnostics" }
)
set(
  "n",
  "<space>dw",
  partial(ts.diagnostics, { prompt_title = "Workspace Diagnostics" }),
  { silent = true, desc = "Telescope: LSP Workspace Diagnostics" }
)
set(
  "n",
  "<space>cs",
  partial(ts.lsp_document_symbols, { symbols = "class" }),
  { silent = true, desc = "Telescope: LSP Class Symbols" }
)
set("n", "<space>ws", function()
  ts.lsp_workspace_symbols { query = vim.fn.input "> " }
end, opts)
set(
  "n",
  "<space>wsd",
  ts.lsp_dynamic_workspace_symbols,
  { silent = true, desc = "Telescope: LSP Dynamic Workspace Symbols " }
)

set("n", "<space>ld", vim.diagnostic.open_float, { desc = "Diagnostic: open float " })
set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostics: go to previous" })
set("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostics: go to next" })
set("n", "<space>rn", vim.lsp.buf.rename, { desc = "LSP: rename" })
set("n", "K", vim.lsp.buf.hover, { desc = "LSP: hover" })
set("n", "<space>f", function()
  require("conform").format { bufnr = vim.api.nvim_get_current_buf(), async = true, lsp_fallback = true }
end, { desc = "LSP: format async" })
-- luasnip
--
set("i", "<C-u>", function()
  if require("luasnip").choice_active() then
    require "luasnip.extras.select_choice"()
  end
end)

set("i", "<c-l>", function()
  if require("luasnip").choice_active() then
    require("luasnip").change_choice(1)
  end
end)
-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
set({ "i", "s" }, "<C-k>", function()
  require("luasnip").jump(1)
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
set({ "i", "s" }, "<C-j>", function()
  require("luasnip").jump(-1)
end, { silent = true })

set("n", "<leader><leader>K", [[<cmd>source ~/.config/nvim/lua/fds/mappings.lua<CR>|<cmd>echo "sourced mappings"<CR>]])
