-- nicer vimtex live-preview
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function() vim.cmd [[write! ]] end,
  buffer = vim.api.nvim_get_current_buf(),
})

vim.cmd [[
  inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
  nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
]]
