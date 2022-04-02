local cmp = require "cmp"
cmp.setup.buffer {
  sources = {
    { name = "omni" },
    { name = "buffer" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
  },
}

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.cmd [[:w! ]]
  end,
})
