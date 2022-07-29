require("bufferline").setup {
  options = {
    view = "multiwindow",
    numbers = function(opts)
      return string.format("%s|%s", opts.lower(opts.ordinal), opts.raise(opts.id))
    end,
    tab_size = 18,
    show_buffer_close_icons = false,
    separator_style = "thin",
    enforce_regular_tabs = true,
  },
}
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", { silent = true })
end
