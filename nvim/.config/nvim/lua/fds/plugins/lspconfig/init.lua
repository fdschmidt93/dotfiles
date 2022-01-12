local null_ls = require "null-ls"
local nvim_lsp = require "lspconfig"
local lsp = vim.lsp

pcall(require, "fds.plugins.lsp.handlers")

local capabilities = lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local on_attach = function()
  require("lsp_signature").on_attach { hint_enable = false }

  vim.cmd [[autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights()]]
end

nvim_lsp.rust_analyzer.setup { on_attach = on_attach, capabilities = capabilities }

local luadev = require("lua-dev").setup {
  lspconfig = {
    cmd = { "lua-language-server" },
    capabilities = capabilities,
  },
}
nvim_lsp.sumneko_lua.setup(luadev)

nvim_lsp.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = { autoSearchPaths = true, useLibraryCodeForTypes = false },
    },
  },
}

local b = null_ls.builtins
null_ls.setup {
  sources = {
    vim.fn.executable "black" == 1 and b.formatting.black or nil,
    vim.fn.executable "isort" == 1 and b.formatting.isort or nil,
    b.formatting.stylua,
  },
  on_attach = on_attach,
  capabilities = capabilities,
}
