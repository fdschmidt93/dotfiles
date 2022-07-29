require("dressing").setup {
  select = {
    telescope = {
      previewer = false,
      borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
      layout_strategy = "vertical",
      layout_config = {
        height = 0.6,
      },
      prompt_prefix = " ",
      sorting_strategy = "ascending",
    },
  },
}
