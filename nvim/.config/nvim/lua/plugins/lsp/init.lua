local nvim_lsp = require "lspconfig"
local lsp = vim.lsp

pcall(require, "plugins.lsp.handlers")

local on_attach = function(client, bufnr)
  require("lsp_signature").on_attach { hint_enable = false }

  lsp.protocol.CompletionItemKind = {
    " Text", -- = 1
    "ƒ Method", -- = 2;
    " Function", -- = 3;
    " Constructor", -- = 4;
    "Field", -- = 5;
    " Variable", -- = 6;
    " Class", -- = 7;
    "ﰮ Interface", -- = 8;
    " Module", -- = 9;
    " Property", -- = 10;
    " Unit", -- = 11;
    " Value", -- = 12;
    "了Enum", -- = 13;
    " Keyword", -- = 14;
    "﬌ Snippet", -- = 15;
    " Color", -- = 16;
    " File", -- = 17;
    "Reference", -- = 18;
    " Folder", -- = 19;
    " EnumMember", -- = 20;
    " Constant", -- = 21;
    " Struct", -- = 22;
    "Event", -- = 23;
    "Operator", -- = 24;
    "TypeParameter", -- = 25;
  }

  vim.cmd [[autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights()]]

  -- Mappings
  local opts = { silent = true }

  nnoremap {
    "<space>ld",
    function()
      lsp.diagnostic.show_line_diagnostics { border = "solid" }
    end,
    opts,
  }
  nnoremap { "[d", lsp.diagnostic.goto_prev, opts }
  nnoremap { "]d", lsp.diagnostic.goto_next, opts }
  nnoremap { "<space>rn", require "plugins.lsp.rename", opts }
  nnoremap { "K", lsp.buf.hover, opts }
  nnoremap { "gs", lsp.buf.signature_help, opts }
  nnoremap {
    "<space>wl",
    function()
      P(lsp.buf.list_workspace_folders())
    end,
    opts,
  }
  nnoremap { "<space>D", lsp.buf.type_definition, opts }
  nnoremap { "<space>wa", lsp.buf.add_workspace_folder, opts }
  nnoremap { "<space>wr", lsp.buf.remove_workspace_folder, opts }
  nnoremap { "<space>f", lsp.buf.formatting, opts }
end

-- nvim_lsp.sumneko_lua.setup {
--   cmd = { "lua-language-server" },
--   on_attach = on_attach,
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = "LuaJIT",
--         -- Setup your lua path
--         path = vim.split(package.path, ";"),
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = { "vim" },
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = {
--           [vim.fn.expand "$VIMRUNTIME/lua"] = true,
--           [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
--         },
--       },
--     },
--   },
-- }

local luadev = require("lua-dev").setup {
  lspconfig = {
    cmd = { "lua-language-server" },
  },
}
nvim_lsp.sumneko_lua.setup(luadev)

nvim_lsp.pyright.setup {
  on_attach = on_attach,
  settings = {
    python = {
      analysis = { autoSearchPaths = true, useLibraryCodeForTypes = false },
    },
  },
}

-- nvim_lsp.efm.setup {
--   init_options = { documentFormatting = true },
--   on_attach = on_attach,
--   filetypes = { "lua", "python" },
--   settings = {
--     rootMarkers = { ".git/" },
--     languages = {
--       lua = {
--         {
--           formatCommand = "stylua --config-path " .. vim.env.HOME .. "/.config/nvim/stylua.toml -",
--           formatStdin = true,
--         },
--       },
--       python = {
--         { formatCommand = vim.env.HOME .. "/miniconda3/bin/black -", formatStdin = true },
--         { formatCommand = vim.env.HOME .. "/miniconda3/bin/isort --stdout --profile black -", formatStdin = true },
--       },
--     },
--   },
-- }

-- TODO revisit once python formatting works better
local null_ls = require "null-ls"
local b = null_ls.builtins

null_ls.config {
  sources = {
    b.formatting.stylua.with {
      args = {
        "--config-path",
        vim.env.HOME .. "/.config/nvim/stylua.toml",
        "-",
      },
    },
    b.formatting.black,
    b.formatting.isort,
  },
}
nvim_lsp["null-ls"].setup { on_attach = on_attach }
