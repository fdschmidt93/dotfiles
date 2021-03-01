local saga = require 'lspsaga'
local nvim_lsp = require 'lspconfig'
local k = require "astronauta.keymap"
local colors = require "colors.gruvbox"
local utils = require "utils"

local nnoremap = k.nnoremap

local lsp_workspace_symbols = function()
  local input = vim.fn.input('Query: ')
  vim.cmd [[normal :esc<CR>]]
  if not input or #input == 0 then return end
  require('telescope.builtin').lsp_workspace_symbols {query = input}
end

local on_attach = function(client, bufnr)

  saga.init_lsp_saga({
    error_sign = '',
    warn_sign = '',
    hint_sign = '',
    infor_sign = ''
  })

  local lsp_highlights = {
    {'LspDiagnosticsDefaultError', {fg = colors.bright_red}},
    {'LspDiagnosticsDefaultWarning', {fg = colors.neutral_yellow}},
    {'LspDiagnosticsDefaultHint', {fg = colors.neutral_aqua}},
    {'LspDiagnosticsDefaultInformation', {fg = colors.light3}}
  }
  for _, hl in pairs(lsp_highlights) do utils.set_hl(hl[1], hl[2]) end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  vim.lsp.handlers["textDocument/publishDiagnostics"] =
      vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- disable virtual text
        virtual_text = false,

        -- show signs
        signs = true,
        -- delay update diagnostics
        update_in_insert = false
      })

  require('vim.lsp.protocol').CompletionItemKind =
      {
        ' Text', -- = 1
        'ƒ Method', -- = 2;
        ' Function', -- = 3;
        ' Constructor', -- = 4;
        'Field', -- = 5;
        ' Variable', -- = 6;
        ' Class', -- = 7;
        'ﰮ Interface', -- = 8;
        ' Module', -- = 9;
        ' Property', -- = 10;
        ' Unit', -- = 11;
        ' Value', -- = 12;
        '了Enum', -- = 13;
        ' Keyword', -- = 14;
        '﬌ Snippet', -- = 15;
        ' Color', -- = 16;
        ' File', -- = 17;
        'Reference', -- = 18;
        ' Folder', -- = 19;
        ' EnumMember', -- = 20;
        ' Constant', -- = 21;
        ' Struct', -- = 22;
        'Event', -- = 23;
        'Operator', -- = 24;
        'TypeParameter' -- = 25;
      }

  vim.cmd(
      [[ autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights() ]])

  -- Mappings
  local opts = {silent = true}
  nnoremap {'gD', vim.lsp.buf.declaration, opts}
  nnoremap {'gd', vim.lsp.buf.definition, opts}
  nnoremap {'K', require"lspsaga.hover".render_hover_doc, opts}
  nnoremap {'gi', vim.lsp.buf.implementation, opts}
  nnoremap {'<space>wa', vim.lsp.buf.add_workspace_folder, opts}
  nnoremap {'<space>wr', vim.lsp.buf.remove_workspace_folder, opts}
  nnoremap {
    '<space>wl',
    function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
    opts
  }
  nnoremap {'<space>D', vim.lsp.buf.type_definition, opts}
  nnoremap {'<space>rn', require"lspsaga.rename".rename, opts}
  nnoremap {
    '<space>ld', require"lspsaga.diagnostic".show_line_diagnostics, opts
  }
  nnoremap {'[d', require"lspsaga.diagnostic".lsp_jump_diagnostic_prev, opts}
  nnoremap {']d', require"lspsaga.diagnostic".lsp_jump_diagnostic_next, opts}
  nnoremap {'<space>ds', require"telescope.builtin".lsp_document_symbols, opts}
  nnoremap {'gr', require"telescope.builtin".lsp_references, opts}
  nnoremap {'<space>f', vim.lsp.buf.formatting, opts}
  nnoremap {'<space>ws', lsp_workspace_symbols, opts}
  nnoremap {'gh', require"lspsaga.provider".lsp_finder, opts}
  nnoremap {'<space>ca', require"lspsaga.codeaction".code_action, opts}
  nnoremap {'gs', require"lspsaga.signaturehelp".signature_help, opts}
end

local servers = {'rust_analyzer', 'jsonls', 'pyright'}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach
    -- capabilities = lsp_status.capabilities
  }
end

require'lspconfig'.sumneko_lua.setup {
  cmd = {"lua-language-server"},
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';')
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'}
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
        }
      }
    }
  }
}

require"lspconfig".efm.setup {
  init_options = {documentFormatting = true},
  -- on_attach = on_attach,
  filetypes = {'lua', 'python'},
  settings = {
    rootMarkers = {".git/"},
    languages = {
      lua = {
        {
          formatCommand = "lua-format -i --indent-width=2 --tab-width=4",
          formatStdin = true
        }
      },
      python = {
        {formatCommand = "black -", formatStdin = true},
        {formatCommand = "isort --stdout --profile black -", formatStdin = true}
      }

    }
  }
}
vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'disable',
  throttle_time = 0,
  source_timeout = 200,
  incomplete_delay = 400,
  allow_prefix_unmatch = false,

  source = {
    path = true,
    buffer = true,
    vsnip = false,
    nvim_lsp = true,
    treesitter = true
  }
}
