return {
  "lervag/vimtex",
  ft = "tex",
  config = function()
    vim.g.tex_flavor = "latex"
    vim.g.vimtex_fold_manual = 1
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_view_general_viewer = "zathura"
    vim.g.vimtex_compiler_progname = "nvr"
    vim.g.vimtex_quickfix_mode = 0
    vim.wo.conceallevel = 2
    vim.g.tex_conceal = "abdgm"
  end,
}
