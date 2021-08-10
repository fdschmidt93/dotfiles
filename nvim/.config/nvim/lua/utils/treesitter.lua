function rename()
  local bufnr = vim.api.nvim_create_buf(true, false)
  local winnr = vim.api.nvim_open_win(
    bufnr,
    true,
    { relative = "cursor", width = 20, height = 1, row = -1, col = 0, style='minimal', border = "rounded" }
  )
  vim.api.nvim_win_set_option(winnr,'scrolloff',0)
  vim.api.nvim_win_set_option(winnr,'sidescrolloff',0)
  vim.api.nvim_buf_set_option(bufnr,'modifiable',true)

  local close_rename_win = function() 
    vim.api.nvim_win_close(winnr, true)
    vim.api.nvim_buf_delete(bufnr, {force=true})
    vim.cmd[[stopinsert!]]
    _G.close_rename_win = nil
  end

  _G.get_text_close_and_rename = function()
    local text = vim.trim(vim.api.nvim_get_current_line())
    close_rename_win()
    if text ~= "" then
      vim.lsp.buf.rename(vim.trim(text))
    end
  end
  
  vim.cmd[[startinsert!]]
  -- inoremap {'<ESC>', function() close_rename_win() end, {buffer=bufnr}}
  -- inoremap {'<CR>', function() get_text_close_and_rename() end, {buffer=bufnr}}
  vim.cmd('inoremap <buffer><nowait><silent><CR> <cmd>lua get_text_close_and_rename()<CR>')
end
