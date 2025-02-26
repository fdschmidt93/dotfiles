local M = {}

M.open_in_oil = function(picker)
  local items = picker:selected { fallback = true }
  assert(#items == 1)
  local item = items[1]
  picker:close()
  local parent
  for path in vim.fs.parents(item.text) do
    parent = path
    if vim.fn.isdirectory(parent) then
      break
    end
  end
  require("oil").open(parent)
end

M.open_subdirs = function(picker)
  local explorer_actions = require "snacks.explorer.actions"
  local Tree = require "snacks.explorer.tree"
  local item = picker:current()
  if not item then
    return
  end
  local parent = item.parent
  if not parent then
    return
  end
  for _, item_ in ipairs(picker.list.items) do
    if item_.parent and item_.parent.file == parent.file then
      Tree:open(item_.file)
    end
  end
  explorer_actions.update(picker, { target = item.file, refresh = true })
end

M.collapse_subdirs = function(picker)
  local explorer_actions = require "snacks.explorer.actions"
  local Tree = require "snacks.explorer.tree"
  local item = picker:current().parent
  if not item then
    return
  end
  Tree:close_all(item.file)

  local file = item.dir and item.file or item.parent.file
  explorer_actions.update(picker, { target = file, refresh = true })
end

return M
