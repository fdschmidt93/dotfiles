local saga = require 'lspsaga'

--local lsp_status = require('lsp-status')
--lsp_status.register_progress()
local nvim_lsp = require('lspconfig')

local system_name
if vim.fn.has("mac") == 1 then
system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
system_name = "Windows"
else
print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"



local on_attach = function(client, bufnr)
-- Errors
vim.api.nvim_command('highlight! link LspDiagnosticsDefaultError  gruvbox_bright_red')
vim.api.nvim_command('highlight! link LspDiagnosticsError  gruvbox_bright_red')
vim.api.nvim_command('highlight! link LspDiagnosticsVirtualTextError  gruvbox_bright_red')
vim.api.nvim_command('highlight! link LspDiagnosticsSignError gruvbox_bright_red')
vim.api.nvim_command('highlight! link LspDiagnosticsFloatingError gruvbox_bright_red')
-- Warnings
vim.api.nvim_command('highlight! link LspDiagnosticsWarning  gruvbox_neutral_yellow')
vim.api.nvim_command('highlight! link LspDiagnosticsVirtualTextWarning  gruvbox_neutral_yellow')
vim.api.nvim_command('highlight! link LspDiagnosticsSignWarning  gruvbox_neutral_yellow')
vim.api.nvim_command('highlight! link LspDiagnosticsWarningFloating gruvbox_neutral_yellow')
-- Information
vim.api.nvim_command('highlight! link LspDiagnosticsInformation gruvbox_light1')
vim.api.nvim_command('highlight! link LspDiagnosticsVirtualTextInformation gruvbox_light1')
vim.api.nvim_command('highlight! link LspDiagnosticsInformationFloating gruvbox_light1')
-- Hint
vim.api.nvim_command('highlight! link LspDiagnosticsHint gruvbox_neutral_aqua')
vim.api.nvim_command('highlight! link LspDiagnosticsSignHint gruvbox_neutral_aqua')
vim.api.nvim_command('highlight! link LspDiagnosticsVirtualTextHint gruvbox_neutral_aqua')
vim.api.nvim_command('highlight! link LspDiagnosticsHintFloating gruvbox_neutral_aqua') --lsp_status.on_attach(client)
saga.init_lsp_saga({
    error_sign = '',
    warn_sign = '',
    hint_sign = '',
    infor_sign = '',
})
vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- disable virtual text
    virtual_text = false,

    -- show signs
    signs = true,

    -- delay update diagnostics
    update_in_insert = false,
  }
)

require('vim.lsp.protocol').CompletionItemKind = {
    ' Text';        -- = 1
    'ƒ Method';      -- = 2;
    ' Function';    -- = 3;
    ' Constructor'; -- = 4;
    'Field';         -- = 5;
    ' Variable';    -- = 6;
    ' Class';       -- = 7;
    'ﰮ Interface';   -- = 8;
    ' Module';      -- = 9;
    ' Property';    -- = 10;
    ' Unit';        -- = 11;
    ' Value';       -- = 12;
    '了Enum';        -- = 13;
    ' Keyword';     -- = 14;
    '﬌ Snippet';     -- = 15;
    ' Color';       -- = 16;
    ' File';        -- = 17;
    'Reference';     -- = 18;
    ' Folder';      -- = 19;
    ' EnumMember';  -- = 20;
    ' Constant';    -- = 21;
    ' Struct';      -- = 22;
    'Event';         -- = 23;
    'Operator';      -- = 24;
    'TypeParameter'; -- = 25;
}


vim.cmd([[ autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights() ]])
lsp_workspace_symbols =  function()
  local input = vim.fn.input('Query: ')
  vim.api.nvim_command('normal :esc<CR>')
  if not input or #input == 0 then return end
  require('telescope.builtin').lsp_workspace_symbols{
      query = input
  }
end
-- Mappings.
local opts = { noremap=true, silent=true }
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua require("lspsaga.hover").render_hover_doc()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua require("lspsaga.rename").rename()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr'n '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ld', '<cmd>lua require("lspsaga.diagnostic").show_line_diagnostics()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_prev()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua require("lspsaga.diagnostic").lsp_jump_diagnostic_next()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ds', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ws', '<cmd>lua lsp_workspace_symbols()<CR>', opts)
-- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<cmd>lua require("lspsaga.provider").lsp_finder()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua require("lspsaga.codeaction").code_action()<CR>', opts)
vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', '<cmd>lua require("lspsaga.signaturehelp").signature_help()<CR>', opts)
end

local servers = {'rust_analyzer', 'jsonls','pyright'}
for _, lsp in ipairs(servers) do
nvim_lsp[lsp].setup {
  on_attach = on_attach,
  --capabilities = lsp_status.capabilities
}
end

require'lspconfig'.sumneko_lua.setup {
    cmd = {"lua-language-server"};
    on_attach = on_attach,
    settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = vim.split(package.path, ';'),
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
            },
          },
        },
    },
}

vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
enabled = true;
autocomplete = true;
debug = false;
min_length = 1;
preselect = 'disable';
throttle_time = 0;
source_timeout = 200;
incomplete_delay = 400;
allow_prefix_unmatch = false;

source = {
path = true;
buffer = true;
vsnip = false;
nvim_lsp = true;
treesitter = true;
-- tabnine = true;
};
}
-- vim.g.indicator_errors = ''
-- vim.g.indicator_warnings = ''
-- vim.g.indicator_info = '🛈'
-- vim.g.indicator_hint = '!'
-- vim.g.indicator_ok = ''
-- vim.g.spinner_frames = {'⣾', '⣽', '⣻', '⢿', '⡿', '⣟', '⣯', '⣷'}
