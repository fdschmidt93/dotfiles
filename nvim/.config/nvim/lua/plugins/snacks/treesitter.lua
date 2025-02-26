local M = {}

M.formatter = function(item)
  local a = Snacks.picker.util.align
  local kind2hl = function(kind)
    local map = { var = "variable.builtin" }
    return "@" .. (map[kind] or kind)
  end
  local ret = {} --@type snacks.picker.Highlight[]
  local ret_line = Snacks.picker.format.lines(item)

  ret[#ret + 1] = { a(tostring(item.pos[1]), 3, { align = "right" }), "SnacksPickerRow" }
  ret[#ret + 1] = { ":", "SnacksPickerDelim" }
  ret[#ret + 1] = { a(tostring(item.pos[2]), 2, { align = "right" }), "SnacksPickerCol" }
  ret[#ret + 1] = { " " }
  ret[#ret + 1] = { a(item.kind, 10, { align = "right" }), "SnacksPickerComment" }
  ret[#ret + 1] = { " " }
  ret[#ret + 1] = { a(item.node_text, 15, { align = "left" }), kind2hl(item.kind) }
  ret[#ret + 1] = { " " }
  ret[#ret + 1] = { "│", "SnacksPickerDelim" }
  ret[#ret + 1] = { " " }

  local length = 0
  for _, r in ipairs(ret) do
    length = length + #r[1]
  end

  local indent = #ret_line[1][1] + 2
  for i = 3, #ret_line do
    local ret_line_item = ret_line[i]
    if ret_line_item.col then
      ret_line_item.col = ret_line_item.col + length - indent
    end
    if ret_line_item.end_col then
      ret_line_item.end_col = ret_line_item.end_col + length - indent
    end
    ret[#ret + 1] = ret_line_item
  end
  return ret
end

---@param opts snacks.picker.buffers.Config
---@type snacks.picker.finder
function M.finder(opts, ctx)
  local __has_ts, _ = pcall(require, "nvim-treesitter")
  if not __has_ts then
    vim.notify "Treesitter requires 'nvim-treesitter'."
    return
  end
  local items = {} ---@type snacks.picker.finder.Item[]
  local current_buf = vim.api.nvim_get_current_buf()
  local extmarks = require("snacks.picker.util.highlight").get_highlights { buf = current_buf }
  local ts_locals = require "nvim-treesitter.locals"
  local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)
  for _, definition in ipairs(ts_locals.get_definitions(current_buf)) do
    local nodes = ts_locals.get_local_nodes(definition)
    for _, node in ipairs(nodes) do
      if node.node then
        local start_row, start_col, end_row, end_col = vim.treesitter.get_node_range(node.node)
        local node_text = vim.treesitter.get_node_text(node.node, current_buf)
        local node_kind = node.kind
        local item = {
          buf = current_buf,
          node_text = node_text,
          kind = node_kind,
          node = node.node,
          pos = { start_row + 1, start_col },
          end_pos = { end_row + 1, end_col },
          text = lines[start_row + 1],
          highlights = extmarks[start_row + 1],
        }
        table.insert(items, item)
      end
    end
  end
  local out = ctx.filter:filter(items)
  return out
end

M.send_to_repl = function(picker)
  local items = picker:selected { fallback = true }
  local bufnr = vim.api.nvim_win_get_buf(picker.main)
  for _, item in ipairs(items) do
    local node = item.node
    if node then
      local parent = node:parent()
      if parent then
        while parent:parent() do
          node = parent
          parent = parent:parent()
        end
      end
      local row1, _, row2, _ = node:range()
      local data = vim.api.nvim_buf_get_lines(bufnr, row1, row2 + 1, false)
      require("resin.api").send { bufnr = bufnr, data = data, history = false }
    end
  end
end

return M
