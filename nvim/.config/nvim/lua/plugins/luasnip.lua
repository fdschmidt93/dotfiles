return {
  "L3MON4D3/LuaSnip",
  lazy = false,
  config = function()
    local types = require "luasnip.util.types"
    local ls = require "luasnip"
    ls.config.set_config {
      update_events = "InsertLeave",
      enable_autosnippets = true,
      region_check_events = "CursorHold,InsertLeave",
      delete_check_events = "TextChanged,InsertEnter",
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "●", "GruvboxOrange" } },
          },
        },
        [types.insertNode] = {
          active = {
            virt_text = { { "●", "GruvboxBlue" } },
          },
        },
      },
    }
    require("luasnip.loaders.from_lua").load()
  end,
}
