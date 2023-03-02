return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  config = function()
    local ls = require "luasnip"
    ls.config.set_config {
      updateevents = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    }
    require("luasnip.loaders.from_lua").load()
  end,
}
