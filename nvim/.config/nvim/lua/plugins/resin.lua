return {
  "fdschmidt93/resin.nvim",
  dev = true,
  event = "VeryLazy",
  config = function()
    require("resin").setup {
      history = {
        path = vim.env.HOME .. "/.local/share/nvim/resin_history.json",
        limit = 10,
      },
      filetype = {
        python = {
          setup_receiver = function()
            local bufnr = vim.tbl_filter(
              function(b) return vim.bo[b].buftype == "terminal" end,
              vim.api.nvim_list_bufs()
            )
            if #bufnr > 1 then
              print "Too many terminals open"
              return
            end
            if bufnr then
              bufnr = bufnr[1]
              return require "resin.receiver.neovim_terminal" {
                bufnr = bufnr,
              }
            end
          end,
        },
      },
    }
  end,
}
