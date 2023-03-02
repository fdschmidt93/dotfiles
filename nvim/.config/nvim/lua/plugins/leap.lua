return {
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    dependencies = "gruvbox",
    config = function()
      require("leap").set_default_keymaps()
    end,
  },
  {
    "ggandor/flit.nvim",
    keys = { "f", "F", "t", "T" },
    dependencies = { "leap.nvim" },
    config = function()
      require("flit").setup {
        keys = { f = "f", F = "F", t = "t", T = "T" },
        -- A string like "nv", "nvo", "o", etc.
        labeled_modes = "nv",
        multiline = true,
        -- Like `leap`s similar argument (call-specific overrides).
        -- E.g.: opts = { equivalence_classes = {} }
        opts = {},
      }
    end,
  },
}
