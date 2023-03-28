return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "gruvbox",
    {
      "github/copilot.vim",
      config = function()
        vim.g.copilot_filetypes = { TelescopePrompt = false }
      end,
    },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "hrsh7th/cmp-omni",
    "saadparwaiz1/cmp_luasnip",
    "lukas-reineke/cmp-rg",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    local border = {
      "🭽",
      "▔",
      "🭾",
      "▕",
      "🭿",
      "▁",
      "🭼",
      "▏",
    }
    local kind_icons = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = "",
    }

    local neorg = require "neorg"
    local function load_completion()
      neorg.modules.load_module("core.norg.completion", nil, {
        engine = "nvim-cmp",
      })
    end
    if neorg.is_loaded() then
      load_completion()
    else
      neorg.callbacks.on_event("core.started", load_completion)
    end

    cmp.setup {
      experimental = {
        ghost_text = true,
      },
      performance = {
        debounce = 10,
        throttle = 0,
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(_, vim_item)
          vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
          return vim_item
        end,
      },
      completion = {
        completeopt = "menu,menuone", -- remove `noselect`.
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = {
          border = border,
          scrollbar = "┃",
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
        documentation = {
          border = border,
          scrollbar = "┃",
          winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        },
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "path" },
        { name = "buffer" },
        { name = "luasnip" },
        { name = "neorg" },
      },
      mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<ESC>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ["<C-y>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
      },
    }
    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
      completion = {
        completeopt = "menu,menuone", -- remove `noselect`.
      },
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  end,
}
