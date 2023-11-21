return {
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/plenary.nvim" },
  {
    "morhetz/gruvbox",
    config = function() require "fds.highlights" end,
  },
  {
    "numToStr/Comment.nvim",
    config = function() require("Comment").setup() end,
  },
  {
    "romainl/vim-cool",
  },
  {
    "https://gitlab.com/yorickpeterse/nvim-pqf.git",
    config = function() require("pqf").setup {} end,
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
    "norcalli/nvim-colorizer.lua",
    ft = "lua",
    config = function() require("colorizer").setup() end,
  },
  {
    "tpope/vim-repeat",
    event = "InsertEnter",
    config = function() vim.cmd [[silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)]] end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup {
        scope = { show_start = false },
      }
    end,
  },
  -- {
  --   "tpope/vim-surround",
  --   event = "InsertEnter",
  -- },
  { "jbyuki/venn.nvim", event = "ModeChanged" },
}
