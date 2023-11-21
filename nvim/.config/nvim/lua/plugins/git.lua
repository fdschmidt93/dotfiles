return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<A-N>", [[<cmd>Git<CR>]], { silent = true })
      vim.keymap.set("n", "<A-a>", [[<cmd>diffget //2<CR>]], { silent = true })
      vim.keymap.set("n", "<A-d>", [[<cmd>diffget //3<CR>]], { silent = true })
    end,
  },
  {
    "TimUntersberger/neogit",
    event = "VeryLazy",
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
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Navigation
          vim.keymap.set("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true })
          vim.keymap.set("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true })

          -- Actions
          vim.keymap.set({ "n", "v" }, "<leader>hs", gs.stage_hunk, { buffer = bufnr, desc = "Gitsigns: Stage Hunk" })
          vim.keymap.set({ "n", "v" }, "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Gitsigns: Reset Hunk" })
          vim.keymap.set("n", "<leader>hS", gs.stage_buffer, { buffer = bufnr, desc = "Gitsigns: Stage Buffer" })
          vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Gitsigns: Undo Stage Hunk" })
          vim.keymap.set("n", "<leader>hR", gs.reset_buffer, { buffer = bufnr, desc = "Gitsigns: Reset Buffer" })
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Gitsigns: Preview Hunk" })
          vim.keymap.set(
            "n",
            "<leader>hb",
            function() gs.blame_line { full = true } end,
            { buffer = bufnr, desc = "Gitsigns: Add Blame Line" }
          )
          vim.keymap.set(
            "n",
            "<leader>tb",
            gs.toggle_current_line_blame,
            { buffer = bufnr, desc = "Gitsigns: Toggle Blame Line" }
          )
          vim.keymap.set("n", "<leader>hd", gs.diffthis, { buffer = bufnr, desc = "Gitsigns: Diff Against Index" })
          vim.keymap.set(
            "n",
            "<leader>hD",
            function() gs.diffthis "~1" end,
            { buffer = bufnr, desc = "Gitsigns: Diff Against Last Commit" }
          )
          vim.keymap.set(
            "n",
            "<leader>td",
            gs.toggle_deleted,
            { buffer = bufnr, desc = "Gitsigns: Show Old Version of Hunk" }
          )
          -- Text object
          vim.keymap.set(
            { "o", "x" },
            "ih",
            ":<C-U>Gitsigns select_hunk<CR>",
            { buffer = bufnr, desc = "Gitsigns: Select Hunk" }
          )
        end,
      }
    end,
  },
}
