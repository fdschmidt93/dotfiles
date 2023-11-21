local repl = require "fds.utils.repl"
local utils = require "fds.utils"
local opts = { silent = true }

-- telescope
local set = vim.keymap.set

-- general
set("i", "jk", "<ESC>", { desc = "Exit insert mode" })
set("n", "oo", [[m`o<Esc>``]], { desc = "Insert line below" })
set("n", "OO", [[m`O<Esc>``]], { desc = "Insert line above" })
set("n", [[<Leader>y]], [['+y']], { desc = "Yank to global register" }) -- Copy to global clipboard with leader prefix
set("n", [[<Leader>p]], [['+p']], { desc = "Paste from global register" }) -- Copp to global clipboard with leader prefix
set("n", "[q", ":cnext<CR>", { desc = "Next QF Item" })
set("n", "]q", ":cprevious<CR>", { desc = "Previous QF Item" })
-- emulate tmux
set("n", "<A-p>", utils.tabedit)
set("n", "<A-o>", utils.tabclose)
-- -- resize more intuitively by direction of arrow key
set("n", [[<A-Left>]], function() utils.resize(true, -2) end)
set("n", [[<A-Right>]], function() utils.resize(true, 2) end)
set("n", [[<A-Down>]], function() utils.resize(false, 2) end)
set("n", [[<A-Up>]], function() utils.resize(false, -2) end)
-- open terminal
set("n", [[<Leader>t]], function() repl.shell { side = "right" } end, { desc = "Terminal: open to right" })
set("n", [[<Leader><C-t>]], function() repl.shell { side = "below" } end, { desc = "Terminal: open below" })

set(
  "n",
  [[<Leader>ti]],
  function() repl.restart_term(repl.wrap_conda_env "ipython", { side = "right" }) end,
  { desc = "Terminal: (re-)start ipython to right" }
)
set(
  "n",
  [[<Leader><C-t>i]],
  function() repl.restart_term(repl.wrap_conda_env "ipython", { side = "below" }) end,
  { desc = "Terminal: (re-)start ipython below" }
)
-- toggle terminal
set("n", "<A-u>", function() repl.toggle_termwin "right" end, { desc = "Terminal: toggle right" })
set("n", "<A-i>", function() repl.toggle_termwin "below" end, { desc = "Terminal: toggle below" })
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

set("n", "<space>", vim.lsp.buf.code_action, { silent = true, desc = "LSP Code Action" })
set("n", "gD", vim.lsp.buf.declaration, { silent = true, desc = "Telescope: LSP Declaration" })
set("n", "gi", vim.lsp.buf.implementation, { silent = true, desc = "Telescope: LSP Implementation" })

-- lsp
set("n", "<space>ld", vim.diagnostic.open_float, { desc = "Diagnostic: open float " })
set("n", "[d", vim.diagnostic.goto_prev, { desc = "Diagnostics: go to previous" })
set("n", "]d", vim.diagnostic.goto_next, { desc = "Diagnostics: go to next" })
set("n", "<space>rn", vim.lsp.buf.rename, { desc = "LSP: rename" })
set("n", "K", vim.lsp.buf.hover, { desc = "LSP: hover" })
set("n", "<space>f", function()
  local bufnr = vim.api.nvim_get_current_buf()
  require("conform").format { bufnr = bufnr, async = true, lsp_fallback = true }
end, { desc = "LSP: format async" })
-- luasnip
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
-- this will expand the current item or jump to the next item within the snippet.
set({ "i", "s" }, "<C-k>", function() require("luasnip").jump(1) end, { silent = true })
-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
set({ "i", "s" }, "<C-j>", function() require("luasnip").jump(-1) end, { silent = true })
set("n", "<leader><leader>K", [[<cmd>source ~/.config/nvim/lua/fds/mappings.lua<CR>|<cmd>echo "sourced mappings"<CR>]])
