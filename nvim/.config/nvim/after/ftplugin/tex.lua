local has_cmp, cmp = pcall(require, "cmp")
if not has_cmp then
  require("packer").loader "nvim-cmp"
  cmp = require "cmp"
end

cmp.setup.buffer {
  sources = {
    { name = "omni" },
    { name = "buffer" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
  },
}

-- nicer vimtex live-preview
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.cmd [[write! ]]
  end,
  buffer = vim.api.nvim_get_current_buf(),
})
