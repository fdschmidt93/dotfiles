local HOME = vim.loop.os_homedir()

-- defer setup for atomic plugins
local defer_require = function(mod)
  return {
    __call = vim.schedule_wrap(require)(mod),
  }
end

-- attempt to find local repo, otherwise fallback to git
local local_or_git = function(path, fallback)
  if path:sub(1, 1) == "~" then
    path = HOME .. path:sub(2, -1)
  end
  if vim.loop.fs_stat(path) then
    return path
  else
    return fallback
  end
end

local modules = {

  -- package management & startup tools
  { "wbthomason/packer.nvim" },
  { local_or_git("~/repos/lua/plenary.nvim", "nvim-lua/plenary.nvim") },
  { "lewis6991/impatient.nvim" },
  { "nathom/filetype.nvim" },

  -- misc tools
  {
    "rcarriga/nvim-notify",
    requires = "plenary.nvim",
    config = function()
      vim.notify = require "notify"
    end,
  },
  { "nanotee/luv-vimdocs" },
  { "romainl/vim-cool" },
  {
    "antoinemadec/FixCursorHold.nvim",
    config = function()
      vim.g.cursorhold_updatetime = 500
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "glacambre/firenvim",
    run = function()
      vim.fn["firenvim#install"](0)
    end,
  },
  { "tpope/vim-surround", event = "InsertEnter" },
  {
    "ggandor/lightspeed.nvim",
    after = "gruvbox",
    config = function()
      vim.api.nvim_set_keymap("", "s", "<Plug>Lightspeed_s", {})
      vim.api.nvim_set_keymap("", "S", "<Plug>Lightspeed_S", {})
      vim.api.nvim_set_keymap("", "f", "<Plug>Lightspeed_f", {})
      vim.api.nvim_set_keymap("", "F", "<Plug>Lightspeed_F", {})
      vim.api.nvim_set_keymap("", "t", "<Plug>Lightspeed_t", {})
      vim.api.nvim_set_keymap("", "T", "<Plug>Lightspeed_T", {})
    end,
  },
  { -- show hex rgb colors
    "norcalli/nvim-colorizer.lua",
    ft = "lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "kkoomen/vim-doge",
    run = ":call doge#install()",
    config = function()
      vim.g.doge_enable_mappings = 1
      vim.g.doge_doc_standard_python = "google"
    end,
  },

  -- theme & icons
  {
    "morhetz/gruvbox",
    config = function()
      require "fds.highlights"
    end,
  },
  { "kyazdani42/nvim-web-devicons" },

  -- filetype plugins
  { "chrisbra/csv.vim", ft = "csv" },
  {
    "iamcco/markdown-preview.nvim",
    run = "cd app && yarn install",
    ft = "markdown",
  },
  {
    "lervag/vimtex",
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
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      vim.g.indent_blankline_char = "│"
      vim.g.indent_blankline_show_current_context = true
    end,
  },

  -- git
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
    -- lazy load with key combination
    keys = "<A-n>",
    config = function()
      require("neogit").setup {
        integrations = { diffview = true },
        signs = {
          section = { "", "" }, -- "", ""
          item = { "▸", "▾" },
          hunk = { "樂", "" },
        },
      }
      vim.keymap.set("n", "<A-n>", [[<cmd>Neogit<CR>]], { silent = true })
    end,
    requires = { "sindrets/diffview.nvim", "plenary.nvim" },
  },
  {
    "lewis6991/gitsigns.nvim",
    requires = { "plenary.nvim" },
    -- lazy load only once a proper buffer has been loaded
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

  -- floating window preview for quickfix list
  {
    "kevinhwang91/nvim-bqf",
    keys = "<C-q>",
    config = function()
      -- toggle qf window vim.keymap.set("n", "<C-q>", require("fds.utils").toggle_qf, { silent = true })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require "fds.plugins.treesitter"
    end,
  },
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle", requires = { "nvim-treesitter" } },
  {
    "jpalardy/vim-slime",
    config = function()
      vim.g.slime_target = "neovim"
      vim.g.slime_python_ipython = 1
    end,
  },
  -- enable repeating supported plugin maps with dot
  {
    "tpope/vim-repeat",
    event = "InsertEnter",
    config = function()
      vim.cmd [[silent! call repeat#set("\<Plug>MyWonderfulMap", v:count)]]
    end,
  },
  {
    "NTBBloodbath/galaxyline.nvim",
    branch = "main",
    config = defer_require "fds.plugins.galaxyline",
  },
  {
    "akinsho/nvim-bufferline.lua",
    after = "gruvbox",
    config = function()
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
        i = tostring(i)
        vim.keymap.set("n", "<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", { silent = true })
      end
    end,
  },
  { -- grepping in large projects
    "ibhagwan/fzf-lua",
    keys = "<space><space>zrg",
    config = function()
      local actions = require "fzf-lua.actions"
      require("fzf-lua").setup {
        winopts = { width = 0.9, preview = {
          layout = "vertical",
        } },
        hl = {},
      }
      require("fzf-lua").setup {
        winopts = {
          hl = {
            normal = "TelescopeNormal",
            border = "TelescopeResultsBorder",
          },
          preview = {
            vertical = "down:45%",
            layout = "vertical",
            delay = 10,
          },
        },
        actions = {
          files = {
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-x"] = actions.file_split, -- harmonize with telescope
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["alt-q"] = actions.file_sel_to_qf,
          },
        },
      }
      vim.keymap.set("n", "<space><space>zrg", "<cmd>lua require('fzf-lua').grep_project()<CR>", { silent = true })
    end,
  },
  {
    local_or_git("~/repos/lua/telescope.nvim", "nvim-telescope/telescope.nvim"),
    requires = {
      "plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-smart-history.nvim", requires = "tami5/sqlite.lua" },
      local_or_git("~/repos/lua/telescope-file-browser.nvim", "nvim-telescope/telescope-file-browser.nvim"),
    },
    config = function()
      require "fds.plugins.telescope"
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    config = function()
      require("dapui").setup()
    end,
    requires = { "mfussenegger/nvim-dap" },
  },
  {
    "mfussenegger/nvim-dap",
    requires = {
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      local opts = { silent = true }
      vim.keymap.set("n", "<F5>", require("dap").continue, opts)
      vim.keymap.set("n", "<F10>", require("dap").step_over, opts)
      vim.keymap.set("n", "<F11>", require("dap").step_into, opts)
      vim.keymap.set("n", "<F12>", require("dap").step_out, opts)
      vim.keymap.set("n", "<space>b", require("dap").toggle_breakpoint, opts)
      vim.keymap.set("n", "<space>dr", require("dap").repl.open, opts)
      vim.keymap.set("n", "<space>dl", require("dap").run_last, opts)
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Breakpoint" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "Stopped" })
      require("telescope").load_extension "dap"
      vim.api.nvim_create_autocmd("FileType", { pattern = "dap-repl", callback = require("dap.ext.autocompl").attach })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      local python_path = string.format("/home/%s/miniconda3/bin/python", vim.env.USER)
      require("dap-python").setup(python_path)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    requires = {
      "folke/lua-dev.nvim",
    },
    config = function()
      require "fds.plugins.lspconfig"
    end,
  },
  { "jose-elias-alvarez/null-ls.nvim", requires = { "plenary.nvim", "neovim/nvim-lspconfig" } },

  {
    "hrsh7th/nvim-cmp",
    branch = "dev",
    after = "gruvbox",
    event = "InsertEnter",
    requires = {
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require "fds.plugins.luasnip"
        end,
      },
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-omni",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-rg",
    },
    config = function()
      require "fds.plugins.cmp"
    end,
  },

  {
    "nvim-neorg/neorg",
    after = "nvim-treesitter",
    config = function()
      require "fds.plugins.norg"
    end,
    requires = { "plenary.nvim", "nvim-neorg/neorg-telescope" },
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require("rust-tools").setup {}
    end,
    requires = "plenary.nvim",
  },
  {
    "stevearc/dressing.nvim",
    config = function()
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
    end,
  },
}

require("packer").startup {
  modules,
  config = {
    -- Move to lua dir so impatient.nvim can cache it
    compile_path = vim.fn.stdpath "config" .. "/lua/packer_compiled.lua",
  },
}
