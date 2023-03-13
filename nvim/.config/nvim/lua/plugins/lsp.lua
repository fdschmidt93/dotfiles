return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "plenary.nvim",
    "jose-elias-alvarez/null-ls.nvim",
    "folke/neodev.nvim",
    "jose-elias-alvarez/typescript.nvim",
  },
  config = function()
    local lsp = vim.lsp
    local null_ls = require "null-ls"

    require("neodev").setup()

    local nvim_lsp = require "lspconfig"

    local capabilities = lsp.protocol.make_client_capabilities()
    capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

    local on_attach = function(client)
      vim.cmd [[autocmd ColorScheme * :lua require('vim.lsp.diagnostic')._define_default_signs_and_highlights()]]
    end

    -- nvim_lsp.rust_analyzer.setup { on_attach = on_attach, capabilities = capabilities }

    nvim_lsp.texlab.setup {}
    nvim_lsp.lua_ls.setup {}
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

    require("typescript").setup {
      disable_commands = false, -- prevent the plugin from creating Vim commands
      debug = false, -- enable debug logging for commands
      go_to_source_definition = {
        fallback = true, -- fall back to standard LSP definition on failure
      },
      server = { -- pass options to lspconfig's setup method
        on_attach = on_attach
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
