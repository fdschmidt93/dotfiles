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
  -- Youtube: How to set up nice formatting for your sources.
  formatting = {
    -- menu = {
    --   buffer = "[buf]",
    --   nvim_lsp = "[LSP]",
    --   nvim_lua = "[api]",
    --   path = "[path]",
    --   luasnip = "[snip]",
    --   rg = "[rg]",
    -- },
    fields = { "kind", "abbr", "menu" },
    format = function(_, vim_item)
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      return vim_item
    end,
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
    },
    documentation = {
      border = border,
      scrollbar = "┃",
    },
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "path" },
    { name = "buffer" },
    { name = "luasnip" },
    { name = "neorg" },
    { name = "rg" },
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
      select = false,
    },
  },
}
