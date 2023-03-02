return {
  {
    "tpope/vim-fugitive",
    keys = "<A-N>",
    config = function()
      vim.keymap.set("n", "<A-N>", [[<cmd>Git<CR>]], { silent = true })
      vim.keymap.set("n", "<A-a>", [[<cmd>diffget //2<CR>]], { silent = true })
      vim.keymap.set("n", "<A-d>", [[<cmd>diffget //3<CR>]], { silent = true })
    end,
  },
  {
    "TimUntersberger/neogit",
    keys = "<A-n>",
    config = function()
      require("neogit").setup {
        disable_commit_confirmation = true,
        integrations = { diffview = true },
        signs = {
          section = { "", "" },
          item = { "▸", "▾" },
          hunk = { "樂", "" },
        },
      }
      vim.keymap.set("n", "<A-n>", [[<cmd>Neogit<CR>]], { silent = true })
    end,
    dependencies = { "sindrets/diffview.nvim", "plenary.nvim" },
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "plenary.nvim" },
    config = function()
      vim.schedule(function()
        require("gitsigns").setup {
          on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
            map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

            -- Actions
            map({ "n", "v" }, "<leader>hs", gs.stage_hunk)
            map({ "n", "v" }, "<leader>hr", gs.reset_hunk)
            map("n", "<leader>hS", gs.stage_buffer)
            map("n", "<leader>hu", gs.undo_stage_hunk)
            map("n", "<leader>hR", gs.reset_buffer)
            map("n", "<leader>hp", gs.preview_hunk)
            map("n", "<leader>hb", function()
              gs.blame_line { full = true }
            end)
            map("n", "<leader>tb", gs.toggle_current_line_blame)
            map("n", "<leader>hd", gs.diffthis)
            map("n", "<leader>hD", function()
              gs.diffthis "~"
            end)
            map("n", "<leader>td", gs.toggle_deleted)

            -- Text object
            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
          end,
        }
      end)
    end,
  },
}
