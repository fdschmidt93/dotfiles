local ok, wf = pcall(require, "vim.lsp._watchfiles")
if ok then
  -- disable lsp watcher. Too slow on linux
  wf._watchfunc = function()
    return function() end
  end
end
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "plenary.nvim",
    "stevearc/conform.nvim",
    "folke/neodev.nvim",
    "jose-elias-alvarez/typescript.nvim",
  },
  config = function()
    local lsp = vim.lsp
    local nvim_lsp = require "lspconfig"

    local capabilities = lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local on_attach = function(client)
      vim.cmd [[autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights()]]
    end

    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    }

    -- nvim_lsp.rust_analyzer.setup { on_attach = on_attach, capabilities = capabilities }

    nvim_lsp.texlab.setup {}
    nvim_lsp.lua_ls.setup {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
    --
    nvim_lsp.pyright.setup {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        python = {
          analysis = { autoSearchPaths = true, useLibraryCodeForTypes = false },
        },
      },
    }
    nvim_lsp.ruff_lsp.setup {
      on_attach = function(client)
        on_attach(client)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end,
      capabilities = capabilities,
    }
    nvim_lsp.rust_analyzer.setup {}
    -- require('lspconfig').fennel_ls.setup{
    --   root_dir = nvim_lsp.util.root_pattern "fnl",
    -- }
    require("lspconfig.configs").fennel_language_server = {
      default_config = {
        -- replace it with true path
        cmd = { "/home/fdschmidt/.cargo/bin/fennel-language-server" },
        filetypes = { "fennel" },
        single_file_support = true,
        -- source code resides in directory `fnl/`
        root_dir = nvim_lsp.util.root_pattern "fnl",
        settings = {
          fennel = {
            workspace = {
              -- If you are using hotpot.nvim or aniseed,
              -- make the server aware of neovim runtime files.
              library = vim.api.nvim_list_runtime_paths(),
            },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      },
    }
    nvim_lsp.fennel_language_server.setup {}

    require("lspconfig").marksman.setup {}

    lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
      underline = true, -- disable virtual text
      virtual_text = true,
      -- show signs
      signs = true,
      -- delay update diagnostics
      update_in_insert = false,
    })

    local border = {
      { "🭽", "FloatBorder" },
      { "▔", "FloatBorder" },
      { "🭾", "FloatBorder" },
      { "▕", "FloatBorder" },
      { "🭿", "FloatBorder" },
      { "▁", "FloatBorder" },
      { "🭼", "FloatBorder" },
      { "▏", "FloatBorder" },
    }

    -- lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
    --   border = border,
    -- })
    --
    -- lsp.handlers["textDocument/signatureHelp"] = lsp.with(lsp.handlers.signature_help, {
    --   border = border,
    -- })

    local signs = { "", "", "", "" }
    local lsp_diagnostic_types = { "Error", "Warning", "Information", "Hint" }
    for i = 1, #lsp_diagnostic_types do
      local diagnostic_type = string.format("LspDiagnosticsSign%s", lsp_diagnostic_types[i])
      local opts = {
        text = signs[i],
        texthl = string.format("LspDiagnosticsDefault%s", lsp_diagnostic_types[i]),
        linehl = "",
        numhl = "",
      }
      vim.fn.sign_define(diagnostic_type, opts)
    end
  end,
}
