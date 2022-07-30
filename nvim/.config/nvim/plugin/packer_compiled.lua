-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/fdschmidt/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/fdschmidt/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/fdschmidt/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/fdschmidt/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/fdschmidt/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["Comment.nvim"] = {
    config = { "\27LJ\2\0025\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/Comment.nvim",
    url = "https://github.com/numToStr/Comment.nvim"
  },
  ["FixCursorHold.nvim"] = {
    config = { "\27LJ\2\0027\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1Ù\1=\1\2\0K\0\1\0\26cursorhold_updatetime\6g\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    config = { "\27LJ\2\0023\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\24fds.plugins.luasnip\frequire\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lsp-signature-help"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp-signature-help",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help"
  },
  ["cmp-omni"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/cmp-omni",
    url = "https://github.com/hrsh7th/cmp-omni"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  ["cmp-rg"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/cmp-rg",
    url = "https://github.com/lukas-reineke/cmp-rg"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["csv.vim"] = {
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/csv.vim",
    url = "https://github.com/chrisbra/csv.vim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/diffview.nvim",
    url = "https://github.com/sindrets/diffview.nvim"
  },
  ["dressing.nvim"] = {
    config = { "\27LJ\2\0024\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\25fds.plugins.dressing\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/dressing.nvim",
    url = "https://github.com/stevearc/dressing.nvim"
  },
  firenvim = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/firenvim",
    url = "https://github.com/glacambre/firenvim"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.galaxyline\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/galaxyline.nvim",
    url = "https://github.com/glepnir/galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\0024\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\25fds.plugins.gitsigns\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  gruvbox = {
    after = { "nvim-cmp", "leap.nvim", "nvim-bufferline.lua" },
    config = { "\27LJ\2\2.\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\19fds.highlights\frequire\0" },
    loaded = true,
    only_config = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/gruvbox",
    url = "https://github.com/morhetz/gruvbox"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.indentline\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["leap.nvim"] = {
    config = { "\27LJ\2\2@\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\24set_default_keymaps\tleap\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/leap.nvim",
    url = "https://github.com/ggandor/leap.nvim"
  },
  ["lua-dev.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/lua-dev.nvim",
    url = "https://github.com/folke/lua-dev.nvim"
  },
  ["luv-vimdocs"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/luv-vimdocs",
    url = "https://github.com/nanotee/luv-vimdocs"
  },
  ["markdown-preview.nvim"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  neogit = {
    config = { "\27LJ\2\2à\2\0\0\5\0\21\0\0256\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\4\0005\2\3\0=\2\5\0015\2\a\0005\3\6\0=\3\b\0025\3\t\0=\3\n\0025\3\v\0=\3\f\2=\2\r\1B\0\2\0016\0\14\0009\0\15\0009\0\16\0'\1\17\0'\2\18\0'\3\19\0005\4\20\0B\0\5\1K\0\1\0\1\0\1\vsilent\2\20<cmd>Neogit<CR>\n<A-n>\6n\bset\vkeymap\bvim\nsigns\thunk\1\3\0\0\bÔ§î\bÔ°≥\titem\1\3\0\0\b‚ñ∏\b‚ñæ\fsection\1\0\0\1\3\0\0\5\5\17integrations\1\0\0\1\0\1\rdiffview\2\nsetup\vneogit\frequire\0" },
    keys = { { "", "<A-n>" } },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  neorg = {
    config = { "\27LJ\2\0020\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\21fds.plugins.norg\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/neorg",
    url = "https://github.com/nvim-neorg/neorg"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.bufferline\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua",
    url = "https://github.com/akinsho/nvim-bufferline.lua"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\2]\0\0\2\0\5\0\n6\0\0\0'\1\1\0B\0\2\0029\0\2\0'\1\3\0B\0\2\0016\0\0\0'\1\4\0B\0\2\1K\0\1\0\20fds.plugins.cmp\fLuaSnip\vloader\vpacker\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\0027\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua",
    url = "https://github.com/norcalli/nvim-colorizer.lua"
  },
  ["nvim-dap"] = {
    config = { "\27LJ\2\2u\0\0\3\0\6\0\v6\0\0\0'\1\1\0B\0\2\0029\0\2\0'\1\3\0'\2\4\0B\0\3\0016\0\0\0'\1\5\0B\0\2\1K\0\1\0\20fds.plugins.dap\20nvim-dap-python\16nvim-dap-ui\vloader\vpacker\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-python"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ui"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\0025\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\26fds.plugins.lspconfig\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-notify"] = {
    config = { "\27LJ\2\0022\0\0\3\0\3\0\0066\0\0\0006\1\2\0'\2\1\0B\1\2\2=\1\1\0K\0\1\0\frequire\vnotify\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-notify",
    url = "https://github.com/rcarriga/nvim-notify"
  },
  ["nvim-surround"] = {
    config = { "\27LJ\2\2ç\1\0\0\5\0\f\0\0156\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\n\0005\2\b\0005\3\4\0005\4\3\0=\4\5\0035\4\6\0=\4\a\3=\3\t\2=\2\v\1B\0\2\1K\0\1\0\15delimiters\1\0\0\npairs\1\0\0\6_\1\3\0\0\6_\6_\6*\1\0\0\1\3\0\0\6*\6*\nsetup\18nvim-surround\frequire\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-surround",
    url = "https://github.com/kylechui/nvim-surround"
  },
  ["nvim-treesitter"] = {
    after = { "neorg" },
    config = { "\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.treesitter\frequire\0" },
    loaded = true,
    only_config = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  playground = {
    commands = { "TSPlaygroundToggle" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/playground",
    url = "https://github.com/nvim-treesitter/playground"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "/home/fdschmidt/repos/lua/plenary.nvim"
  },
  ["resin.nvim"] = {
    config = { "\27LJ\2\0021\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\22fds.plugins.resin\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/resin.nvim",
    url = "/home/fdschmidt/repos/lua/resin.nvim/"
  },
  ["rust-tools.nvim"] = {
    config = { "\27LJ\2\2<\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\15rust-tools\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/kkharji/sqlite.lua"
  },
  ["telescope-dap.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim",
    url = "https://github.com/nvim-telescope/telescope-dap.nvim"
  },
  ["telescope-file-browser.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
    url = "/home/fdschmidt/repos/lua/telescope-file-browser.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-smart-history.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-smart-history.nvim",
    url = "https://github.com/nvim-telescope/telescope-smart-history.nvim"
  },
  ["telescope-symbols.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-symbols.nvim",
    url = "https://github.com/nvim-telescope/telescope-symbols.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\0025\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\26fds.plugins.telescope\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "/home/fdschmidt/repos/lua/telescope.nvim"
  },
  ["vim-cool"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/vim-cool",
    url = "https://github.com/romainl/vim-cool"
  },
  ["vim-doge"] = {
    config = { "\27LJ\2\2f\0\0\2\0\5\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0K\0\1\0\vgoogle\29doge_doc_standard_python\25doge_enable_mappings\6g\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/vim-doge",
    url = "https://github.com/kkoomen/vim-doge"
  },
  ["vim-fugitive"] = {
    config = { "\27LJ\2\2Ê\1\0\0\5\0\r\0\0256\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\4\0'\3\5\0005\4\6\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\a\0'\3\b\0005\4\t\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\n\0'\3\v\0005\4\f\0B\0\5\1K\0\1\0\1\0\1\vsilent\2\25<cmd>diffget //3<CR>\n<A-d>\1\0\1\vsilent\2\25<cmd>diffget //2<CR>\n<A-a>\1\0\1\vsilent\2\17<cmd>Git<CR>\n<A-N>\6n\bset\vkeymap\bvim\0" },
    keys = { { "", "<A-N>" } },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-repeat"] = {
    config = { "\27LJ\2\2]\0\0\2\0\3\0\0056\0\0\0009\0\1\0'\1\2\0B\0\2\1K\0\1\0>silent! call repeat#set(\"\\<Plug>MyWonderfulMap\", v:count)\bcmd\bvim\0" },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  vimtex = {
    config = { "\27LJ\2\0020\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\21fds.plugins.norg\frequire\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex",
    url = "https://github.com/lervag/vimtex"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: dressing.nvim
time([[Config for dressing.nvim]], true)
try_loadstring("\27LJ\2\0024\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\25fds.plugins.dressing\frequire\0", "config", "dressing.nvim")
time([[Config for dressing.nvim]], false)
-- Config for: gruvbox
time([[Config for gruvbox]], true)
try_loadstring("\27LJ\2\2.\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\19fds.highlights\frequire\0", "config", "gruvbox")
time([[Config for gruvbox]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.indentline\frequire\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\0025\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: vim-doge
time([[Config for vim-doge]], true)
try_loadstring("\27LJ\2\2f\0\0\2\0\5\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0K\0\1\0\vgoogle\29doge_doc_standard_python\25doge_enable_mappings\6g\bvim\0", "config", "vim-doge")
time([[Config for vim-doge]], false)
-- Config for: resin.nvim
time([[Config for resin.nvim]], true)
try_loadstring("\27LJ\2\0021\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\22fds.plugins.resin\frequire\0", "config", "resin.nvim")
time([[Config for resin.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\2\0025\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\26fds.plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\0024\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\25fds.plugins.gitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\0025\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\26fds.plugins.lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.galaxyline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: nvim-notify
time([[Config for nvim-notify]], true)
try_loadstring("\27LJ\2\0022\0\0\3\0\3\0\0066\0\0\0006\1\2\0'\2\1\0B\1\2\2=\1\1\0K\0\1\0\frequire\vnotify\bvim\0", "config", "nvim-notify")
time([[Config for nvim-notify]], false)
-- Config for: FixCursorHold.nvim
time([[Config for FixCursorHold.nvim]], true)
try_loadstring("\27LJ\2\0027\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1Ù\1=\1\2\0K\0\1\0\26cursorhold_updatetime\6g\bvim\0", "config", "FixCursorHold.nvim")
time([[Config for FixCursorHold.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-cmp ]]

-- Config for: nvim-cmp
try_loadstring("\27LJ\2\2]\0\0\2\0\5\0\n6\0\0\0'\1\1\0B\0\2\0029\0\2\0'\1\3\0B\0\2\0016\0\0\0'\1\4\0B\0\2\1K\0\1\0\20fds.plugins.cmp\fLuaSnip\vloader\vpacker\frequire\0", "config", "nvim-cmp")

vim.cmd [[ packadd leap.nvim ]]

-- Config for: leap.nvim
try_loadstring("\27LJ\2\2@\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\24set_default_keymaps\tleap\frequire\0", "config", "leap.nvim")

vim.cmd [[ packadd nvim-bufferline.lua ]]

-- Config for: nvim-bufferline.lua
try_loadstring("\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.bufferline\frequire\0", "config", "nvim-bufferline.lua")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.api.nvim_set_keymap("", "<A-N>", "<cmd>lua require('packer.load')({'vim-fugitive'}, { keys = [=[<lt>A-N>]=], prefix = '' }, _G.packer_plugins)<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("", "<A-n>", "<cmd>lua require('packer.load')({'neogit'}, { keys = [=[<lt>A-n>]=], prefix = '' }, _G.packer_plugins)<cr>", { noremap = true, silent = true })
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType lua ++once lua require("packer.load")({'nvim-colorizer.lua', 'nvim-dap'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'nvim-dap'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType csv ++once lua require("packer.load")({'csv.vim'}, { ft = "csv" }, _G.packer_plugins)]]
vim.cmd [[au FileType norg ++once lua require("packer.load")({'neorg'}, { ft = "norg" }, _G.packer_plugins)]]
vim.cmd [[au FileType rust ++once lua require("packer.load")({'rust-tools.nvim', 'nvim-dap'}, { ft = "rust" }, _G.packer_plugins)]]
vim.cmd [[au FileType tex ++once lua require("packer.load")({'vimtex'}, { ft = "tex" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-surround', 'vim-repeat'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]], true)
vim.cmd [[source /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/neorg/ftdetect/norg.vim]], false)
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]], true)
vim.cmd [[source /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]], false)
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]], true)
vim.cmd [[source /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/cls.vim]], false)
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], true)
vim.cmd [[source /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], false)
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]], true)
vim.cmd [[source /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tikz.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
