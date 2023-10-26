local api = vim.api
local set = vim.keymap.set

-- initialize ipython terminal with shell's conda environment
local has_term = false
for _, chan in ipairs(api.nvim_list_chans()) do
  if chan.mode == "terminal" then
    has_term = true
    break
  end
end

if not has_term then
  local repl = require "fds.utils.repl"
  local termbuf = repl.shell { cmd = repl.wrap_conda_env "ipython", side = "below", listed = false }
  repl.toggle_termwin("below", termbuf)
end

-- Send ranges of treesitter query to resin receiver of current buffer.
-- @param query string: treesitter queryj
-- @param opts table
-- @field bufnr number: buffer to send to (default: current buffer)
-- @field filetype string: filetype of buffer to send to (default: current buffer filetype)
-- @field filter function: function(data) return modified_data end to filter lines of data to send
local function send_treesitter_query(query, opts)
  opts = opts or {}
  opts.bufnr = vim.F.if_nil(opts.bufnr, api.nvim_get_current_buf())
  opts.filetype = vim.F.if_nil(opts.filetype, vim.bo[opts.bufnr].filetype)
  local language_tree = vim.treesitter.get_parser(opts.bufnr, opts.filetype)
  local syntax_tree = language_tree:parse()[1]
  local root = syntax_tree:root()
  local ts_query = vim.treesitter.parse_query(opts.filetype, query)

  local data = {}
  for _, node, _ in ts_query:iter_captures(root, 1) do
    local row1, _, row2, _ = node:range()
    local lines = api.nvim_buf_get_lines(opts.bufnr, row1, row2 + 1, false)
    for _, line in ipairs(lines) do
      table.insert(data, line)
    end
  end
  if not vim.tbl_isempty(data) then
    if type(opts.filter) == "function" then
      data = opts.filter(data)
    end
    require("resin.api").send { data = data, history = false }
  else
    vim.notify("treesitter query not found!", vim.log.levels.INFO, { title = "resin.nvim" })
  end
end

-- keymaps
set({ "n", "x" }, "<C-s>", function()
  require("resin.api").send {
    on_before_send = function(_, data)
      assert(#data == 1, "Cannot inspect shape for multiline statement")
      data[1] = string.format([[print(%s.shape if hasattr(%s, "shape") else len(%s));]], data[1], data[1], data[1])
    end,
  }
end, { buffer = 0, desc = "resin.python: print len/shape of selection" })
set("n", "<C-c><C-i>", function()
  send_treesitter_query [[((import_statement) @i (#not-has-parent? @i "block"))
((import_from_statement) @i (#not-has-parent? @i "block"))
((expression_statement) @expr (#not-has-parent? @expr "block"))
]]
end, { buffer = 0, desc = "resin.python: send all import statements" })

set("n", "<C-c><C-f>", function()
  send_treesitter_query [[(function_definition) @include]]
end, { buffer = 0, desc = "resin.python: send all function definitions" })
