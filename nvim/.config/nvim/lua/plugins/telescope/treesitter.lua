local M = {}

-- Send top-level (parent) node (child of parent) of telescope.builtin.treesitter selection to resin.nvim
-- @param prompt_bufnr number: prompt_bufnr of current picker
M.send_to_repl = function(prompt_bufnr)
  local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  local bufnr = vim.api.nvim_win_get_buf(current_picker.original_win_id)

  local selections = current_picker:get_multi_selection()
  if vim.tbl_isempty(selections) then
    local entry = require("telescope.actions.state").get_selected_entry()
    table.insert(selections, entry)
  end
  for _, selection in ipairs(selections) do
    local node = selection.value
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
