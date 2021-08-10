local api = vim.api

-- emulate lspsaga's rename
local function rename()
  -- set cursor to beginning of word and get position
  vim.fn.search(vim.fn.expand "<cword>", "bc")
  local cur_pos = api.nvim_win_get_cursor(0)

  -- create floating window
  local bufnr = api.nvim_create_buf(false, true)
  local winnr = api.nvim_open_win(bufnr, true, {
    relative = "cursor",
    width = 20,
    height = 1,
    row = -3,
    col = -1,
    style = "minimal",
    border = "rounded",
  })
  vim.cmd [[startinsert]]
  api.nvim_win_set_option(winnr, "scrolloff", 0)
  api.nvim_win_set_option(winnr, "sidescrolloff", 0)
  api.nvim_buf_set_option(bufnr, "modifiable", true)

  -- create helpers
  _G._close_rename_win = function()
    -- TODO why does this not work?
    -- if api.nvim_get_mode().mode == 'i' then
    if vim.fn.mode() == "i" then
      -- TODO why are buffer-local keybindings not released when using stopinsert?
      -- vim.cmd [[stopinsert]]
      local key = api.nvim_replace_termcodes("<ESC>", true, false, true)
      api.nvim_feedkeys(key, "n", true)
    end
    pcall(api.nvim_win_close, winnr, true)
    local pos = { cur_pos[1], cur_pos[2] + 1 }
    api.nvim_win_set_cursor(0, pos)
    -- do not clutter global namespace
    _G._close_rename_win = nil
  end

  _G._get_text_close_and_rename = function()
    local text = vim.trim(api.nvim_get_current_line())
    _close_rename_win()
    if text ~= "" then
      vim.lsp.buf.rename(vim.trim(text))
    end
    _G.get_text_close_and_rename = nil
  end

  vim.cmd [[inoremap <buffer><nowait><silent><CR> <cmd>lua _get_text_close_and_rename()<CR>]]
  vim.cmd [[inoremap <buffer><nowait><silent><ESC> <cmd>lua _close_rename_win()<CR>]]
end

return rename
