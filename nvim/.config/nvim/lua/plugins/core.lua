return {
  {
    "romainl/vim-cool",
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require("rust-tools").setup {}
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter" },
    ft = { "markdown", "norg" },
    config = function()
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

      require("ufo").setup {
        provider_selector = function(_, filetype, _)
          if filetype ~= "markdown" then
            return ""
          end
          return { "treesitter", "indent" }
        end,
      }
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",

    config = function()
      require("mkdnflow").setup {
        mappings = {
          MkdEnter = false,
          MkdnCreateLink = { "n", "<leader>cl" },
          MkdnFollowLink = { "n", "<leader>fl" },
        },
      }
      local links = require "mkdnflow.links"
      local followLink = links.followLink
      links.followLink = function(path, anchor)
        if path or anchor then
          path, anchor = path, anchor
        else
          path, anchor, _ = links.getLinkPart(links.getLinkUnderCursor(), "source")
        end
        local uri = "phd://"
        if path:find(uri) then
          vim.system { "xdg-open", path }
          return
        end
        followLink(path, anchor)
      end
    end,
  },
  {
    "morhetz/gruvbox",
    config = function()
      require "fds.highlights"
    end,
  },
  { "dhruvasagar/vim-table-mode", ft = "markdown" },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    ft = "markdown",
  },
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    config = function()
      vim.g.doge_enable_mappings = 1
      vim.g.doge_doc_standard_python = "google"
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.g.indent_blankline_char = "│" --  "▏"
      vim.g.indent_blankline_show_current_context = true
      vim.g.indent_blankline_context_char = "│" --  "▏"
      vim.g.indent_blankline_filetype_exclude = {
        "lspinfo",
        "packer",
        "checkhealth",
        "help",
        "man",
        "norg",
      }
    end,
  },
  { "nvim-lua/plenary.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "norcalli/nvim-colorizer.lua",
    ft = "lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "tpope/vim-repeat",
    event = "InsertEnter",
    config = function()
      vim.cmd [[silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)]]
    end,
  },
  {
    "tpope/vim-surround",
    event = "InsertEnter",
  },
  { "jbyuki/venn.nvim", event = "ModeChanged" },
  {
    "rcarriga/nvim-notify",
    dependencies = "plenary.nvim",
    config = function()
      vim.notify = require "notify"
    end,
  },
}
