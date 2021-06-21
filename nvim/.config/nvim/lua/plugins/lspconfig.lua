local saga = require "lspsaga"
local lsp = vim.lsp
local ts = require "telescope.builtin"
local nvim_lsp = require "lspconfig"
local nnoremap = require("astronauta.keymap").nnoremap
local colors = require "highlights.gruvbox"
local utils = require "utils"

local on_attach = function(client, bufnr)
  saga.init_lsp_saga {
    error_sign = "",
    warn_sign = "",
    hint_sign = "",
    infor_sign = "",
    border_style = "round",
  }
  R("lsp_signature").on_attach { hint_enable = false }
  local lsp_highlights = {
    { "LspDiagnosticsDefaultError", { fg = colors.bright_red } },
    { "LspDiagnosticsDefaultWarning", { fg = colors.neutral_yellow } },
    { "LspDiagnosticsDefaultHint", { fg = colors.neutral_aqua } },
    { "LspDiagnosticsDefaultInformation", { fg = colors.light3 } },
  }
  for _, hl in pairs(lsp_highlights) do
    utils.set_hl(hl[1], hl[2])
  end

  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      underline = false,
      -- disable virtual text
      virtual_text = false,
      -- show signs
      signs = true,
      -- delay update diagnostics
      update_in_insert = false,
    }
  )

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
  nnoremap { "<space>ld", R("lspsaga.diagnostic").show_line_diagnostics, opts }
  nnoremap { "[d", R("lspsaga.diagnostic").lsp_jump_diagnostic_prev, opts }
  nnoremap { "]d", R("lspsaga.diagnostic").lsp_jump_diagnostic_next, opts }
  nnoremap { "<space>ca", R("lspsaga.codeaction").code_action, opts }
  nnoremap { "<space>rn", R("lspsaga.rename").rename, opts }
  nnoremap { "K", R("lspsaga.hover").render_hover_doc, opts }
  nnoremap { "gh", R("lspsaga.provider").lsp_finder, opts }
  nnoremap { "gs", R("lspsaga.signaturehelp").signature_help, opts }
  nnoremap {
    "<space>wl",
    function()
      P(lsp.buf.list_workspace_folders())
    end,
    opts,
  }
  nnoremap { "<space>D", vim.lsp.buf.type_definition, opts }
  nnoremap { "<space>wa", vim.lsp.buf.add_workspace_folder, opts }
  nnoremap { "<space>wr", vim.lsp.buf.remove_workspace_folder, opts }
  nnoremap { "<space>f", vim.lsp.buf.formatting, opts }
  nnoremap { "gD", vim.lsp.buf.declaration, opts }
  nnoremap { "gi", vim.lsp.buf.implementation, opts }
  nnoremap { "gd", ts.lsp_definitions, opts }
  nnoremap { "gr", ts.lsp_references, opts }
  nnoremap { "<space>ds", ts.lsp_document_symbols, opts }
  nnoremap { "<space>db", ts.lsp_document_diagnostics, opts }
  nnoremap { "<space>dw", ts.lsp_workspace_diagnostics, opts }
  nnoremap {
    "<space>ws",
    function()
      ts.lsp_workspace_symbols { query = vim.fn.input "> " }
    end,
    opts,
  }
  nnoremap { "<space>wsd", ts.lsp_dynamic_workspace_symbols, opts }
end

nvim_lsp.sumneko_lua.setup {
  cmd = { "lua-language-server" },
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
        },
      },
    },
  },
}

nvim_lsp.pyright.setup {
  on_attach = on_attach,
  settings = {
    python = {
      analysis = { autoSearchPaths = true, useLibraryCodeForTypes = false },
    },
  },
}

local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
  b.formatting.stylua.with {
    args = {
      "--config-path",
      vim.env.HOME .. "/.config/nvim/stylua.toml",
      "-",
    },
  },
  b.formatting.black,
  b.formatting.isort,
}

null_ls.setup {
  sources = sources,
}
