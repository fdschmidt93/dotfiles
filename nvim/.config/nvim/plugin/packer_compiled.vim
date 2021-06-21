" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
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
local package_path_str = "/home/fdschmidt/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/fdschmidt/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/fdschmidt/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/fdschmidt/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/fdschmidt/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
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
  ["FixCursorHold.nvim"] = {
    config = { "\27LJ\1\0027\0\0\2\0\3\0\0054\0\0\0007\0\1\0'\1�\1:\1\2\0G\0\1\0\26cursorhold_updatetime\6g\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/FixCursorHold.nvim"
  },
  ["astronauta.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/astronauta.nvim"
  },
  ["csv.vim"] = {
    loaded = false,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/csv.vim"
  },
  ["diffview.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/diffview.nvim"
  },
  ["fzf.vim"] = {
    config = { "\27LJ\1\2U\0\0\3\0\3\0\0064\0\0\0003\1\1\0003\2\2\0;\2\3\1>\0\2\1G\0\1\0\1\0\1\vsilent\2\1\3\0\0\22<space><space>zrg\16<cmd>Rg<CR>\rnnoremap\0" },
    keys = { { "", "<space><space>zrg" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/fzf.vim"
  },
  ["galaxyline.nvim"] = {
    config = { "\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins.statusline\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\1\0026\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/gitsigns.nvim"
  },
  gruvbox = {
    after = { "nvim-dap", "hop.nvim", "nvim-bufferline.lua", "nvim-colorizer.lua" },
    only_config = true
  },
  ["hologram.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/hologram.nvim"
  },
  ["hop.nvim"] = {
    config = { "\27LJ\1\2�\5\0\0\v\0\29\0T4\0\0\0002\1\3\0004\2\1\0;\2\1\0014\2\2\0;\2\2\1>\0\2\4D\3 �\16\5\4\0003\6\3\0004\a\4\0%\b\5\0>\a\2\0027\a\6\a;\a\2\6>\5\2\1\16\5\4\0003\6\a\0004\a\4\0%\b\5\0>\a\2\0027\a\b\a;\a\2\6>\5\2\1\16\5\4\0003\6\t\0004\a\4\0%\b\5\0>\a\2\0027\a\n\a;\a\2\6>\5\2\1\16\5\4\0003\6\v\0004\a\4\0%\b\5\0>\a\2\0027\a\f\a;\a\2\6>\5\2\1B\3\3\3N\3�4\0\4\0%\1\r\0>\0\2\0024\1\4\0%\2\14\0>\1\2\0022\2\5\0003\3\15\0003\4\17\0007\5\16\0:\5\18\4;\4\2\3;\3\1\0023\3\19\0003\4\21\0007\5\20\0:\5\18\4;\4\2\3;\3\2\0023\3\22\0003\4\24\0007\5\23\0:\5\18\4;\4\2\3;\3\3\0023\3\25\0003\4\27\0007\5\26\0:\5\18\4;\4\2\3;\3\4\0024\3\0\0\16\4\2\0>\3\2\4D\6\4�7\b\28\0018\t\1\a8\n\2\a>\b\3\1B\6\3\3N\6�G\0\1\0\vset_hl\1\0\0\vlight4\1\2\0\0\17HopUnmatched\1\0\0\18neutral_green\1\2\0\0\16HopNextKey2\1\0\1\bgui\19bold,underline\17bright_green\1\2\0\0\16HopNextKey1\afg\1\0\1\bgui\19bold,underline\18bright_orange\1\2\0\0\15HopNextKey\nutils\23highlights.gruvbox\18hint_patterns\1\2\0\0\n<C-/>\15hint_lines\1\2\0\0\n<C-l>\15hint_char1\1\2\0\0\n<C-f>\15hint_char2\bhop\frequire\1\2\0\0\n<C-s>\rvnoremap\rnnoremap\npairs\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/hop.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\1\2�\1\0\0\2\0\a\0\r4\0\0\0007\0\1\0003\1\3\0:\1\2\0004\0\0\0007\0\1\0%\1\5\0:\1\4\0004\0\0\0007\0\1\0)\1\2\0:\1\6\0G\0\1\0*indent_blankline_show_current_context\b│\20indentLine_char\1\3\0\0\vpython\blua\30indent_blankline_filetype\6g\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["markdown-preview.nvim"] = {
    commands = { "MarkdownPreview" },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim"
  },
  neogit = {
    config = { "\27LJ\1\2�\1\0\0\4\0\17\0\0224\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\0013\2\a\0003\3\6\0:\3\b\0023\3\t\0:\3\n\0023\3\v\0:\3\f\2:\2\r\1>\0\2\0014\0\14\0003\1\15\0003\2\16\0;\2\3\1>\0\2\1G\0\1\0\1\0\1\vsilent\2\1\3\0\0\n<A-n>\20<cmd>Neogit<CR>\rnnoremap\nsigns\thunk\1\3\0\0\b樂\b\titem\1\3\0\0\b▸\b▾\fsection\1\0\0\1\3\0\0\5\5\17integrations\1\0\0\1\0\1\rdiffview\2\nsetup\vneogit\frequire\0" },
    keys = { { "", "<A-n>" } },
    loaded = false,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/neogit"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/null-ls.nvim"
  },
  ["nvim-bqf"] = {
    config = { "\27LJ\1\2i\0\0\4\0\6\0\v4\0\0\0003\1\1\0004\2\2\0%\3\3\0>\2\2\0027\2\4\2;\2\2\0013\2\5\0;\2\3\1>\0\2\1G\0\1\0\1\0\1\vsilent\2\14toggle_qf\nutils\frequire\1\2\0\0\n<C-q>\rnnoremap\0" },
    keys = { { "", "<C-q>" } },
    loaded = false,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-bqf"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\1\2�\1\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\1>\0\2\1G\0\1\0\foptions\1\0\0\1\0\b\17number_style\16superscript\fnumbers\fordinal\28show_buffer_close_icons\1\20separator_style\tthin\tview\16multiwindow\rtab_size\3\18\rmappings\2\25enforce_regular_tabs\2\nsetup\15bufferline\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\1\0027\0\0\2\0\3\0\0064\0\0\0%\1\1\0>\0\2\0027\0\2\0>\0\1\1G\0\1\0\nsetup\14colorizer\frequire\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    after_files = { "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-compe/after/plugin/compe.vim" },
    config = { "\27LJ\1\2�\2\0\0\3\0\n\0\r4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\4\0%\1\5\0>\0\2\0027\0\6\0003\1\a\0003\2\b\0:\2\t\1>\0\2\1G\0\1\0\vsource\1\0\5\rnvim_lsp\2\vbuffer\2\nvsnip\1\15treesitter\2\tpath\2\1\0\t\17autocomplete\2\19source_timeout\3�\1\fenabled\2\ndebug\1\14preselect\fdisable\21incomplete_delay\3�\3\25allow_prefix_unmatch\1\15min_length\3\1\18throttle_time\3\0\nsetup\ncompe\frequire\21menuone,noselect\16completeopt\6o\bvim\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-compe"
  },
  ["nvim-dap"] = {
    after = { "nvim-dap-python" },
    config = { "\27LJ\1\2�\5\0\0\5\0\28\0T3\0\0\0004\1\1\0003\2\2\0004\3\3\0%\4\4\0>\3\2\0027\3\5\3;\3\2\2;\0\3\2>\1\2\0014\1\1\0003\2\6\0004\3\3\0%\4\4\0>\3\2\0027\3\a\3;\3\2\2;\0\3\2>\1\2\0014\1\1\0003\2\b\0004\3\3\0%\4\4\0>\3\2\0027\3\t\3;\3\2\2;\0\3\2>\1\2\0014\1\1\0003\2\n\0004\3\3\0%\4\4\0>\3\2\0027\3\v\3;\3\2\2;\0\3\2>\1\2\0014\1\1\0003\2\f\0004\3\3\0%\4\4\0>\3\2\0027\3\r\3;\3\2\2;\0\3\2>\1\2\0014\1\1\0003\2\14\0004\3\3\0%\4\4\0>\3\2\0027\3\15\0037\3\16\3;\3\2\2;\0\3\2>\1\2\0014\1\1\0003\2\17\0004\3\3\0%\4\4\0>\3\2\0027\3\18\3;\3\2\2;\0\3\2>\1\2\0014\1\19\0007\1\20\0017\1\21\1%\2\22\0003\3\23\0>\1\3\0014\1\19\0007\1\20\0017\1\21\1%\2\24\0003\3\25\0>\1\3\0014\1\3\0%\2\26\0>\1\2\0027\1\27\1%\2\4\0>\1\2\1G\0\1\0\19load_extension\14telescope\1\0\2\ttext\b\vtexthl\fStopped\15DapStopped\1\0\2\ttext\b\vtexthl\15Breakpoint\18DapBreakpoint\16sign_define\afn\bvim\rrun_last\1\2\0\0\14<space>dl\topen\trepl\1\2\0\0\14<space>dr\22toggle_breakpoint\1\2\0\0\r<space>b\rstep_out\1\2\0\0\n<F12>\14step_into\1\2\0\0\n<F11>\14step_over\1\2\0\0\n<F10>\rcontinue\bdap\frequire\1\2\0\0\t<F5>\rnnoremap\1\0\1\vsilent\2\0" },
    load_after = {},
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-dap"
  },
  ["nvim-dap-python"] = {
    config = { "\27LJ\1\2�\1\0\0\4\0\t\0\0154\0\0\0007\0\1\0%\1\2\0004\2\3\0007\2\4\2%\3\5\0>\2\2\0=\0\1\0024\1\6\0%\2\a\0>\1\2\0027\1\b\1\16\2\0\0>\1\2\1G\0\1\0\nsetup\15dap-python\frequire\tUSER\vgetenv\aos#/home/%s/miniconda3/bin/python\vformat\vstring\0" },
    load_after = {
      ["nvim-dap"] = true
    },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-dap-python"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins.lspconfig\frequire\0" },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-lspconfig"
  },
  ["nvim-tree"] = {
    config = { "\27LJ\1\2�\1\0\0\3\0\a\0\0144\0\0\0003\1\1\0003\2\2\0;\2\3\1>\0\2\0014\0\3\0007\0\4\0'\1\1\0:\1\5\0004\0\3\0007\0\4\0'\1\1\0:\1\6\0G\0\1\0%nvim_tree_highlight_opened_files\29nvim_tree_indent_markers\6g\bvim\1\0\1\vsilent\2\1\3\0\0\n<A-m>\28<cmd>NvimTreeToggle<CR>\rnnoremap\0" },
    keys = { { "", "<A-m>" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-tree"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins.treesitter\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-treesitter-textobjects"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["telescope-dap.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    after = { "nvim-dap" },
    only_config = true
  },
  ["vim-commentary"] = {
    keys = { { "", "gc" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-commentary"
  },
  ["vim-cool"] = {
    keys = { { "", "/" } },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-cool"
  },
  ["vim-doge"] = {
    config = { "\27LJ\1\0026\0\0\2\0\3\0\0054\0\0\0007\0\1\0'\1\1\0:\1\2\0G\0\1\0\25doge_enable_mappings\6g\bvim\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-doge"
  },
  ["vim-fugitive"] = {
    commands = { "Git" },
    loaded = false,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-fugitive"
  },
  ["vim-repeat"] = {
    config = { '\27LJ\1\2]\0\0\2\0\3\0\0054\0\0\0007\0\1\0%\1\2\0>\0\2\1G\0\1\0>silent! call repeat#set("\\<Plug>MyWonderfulMap", v:count)\bcmd\bvim\0' },
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-repeat"
  },
  ["vim-slime"] = {
    config = { "\27LJ\1\2Z\0\0\2\0\5\0\t4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0'\1\1\0:\1\4\0G\0\1\0\25slime_python_ipython\vneovim\17slime_target\6g\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/vim-slime"
  },
  ["vim-sneak"] = {
    after = { "hop.nvim" },
    only_config = true
  },
  ["vim-surround"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-surround"
  },
  vimtex = {
    config = { "\27LJ\1\2�\2\0\0\2\0\15\0!4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0'\1\1\0:\1\4\0004\0\0\0007\0\1\0'\1\1\0:\1\5\0004\0\0\0007\0\1\0%\1\a\0:\1\6\0004\0\0\0007\0\1\0%\1\t\0:\1\b\0004\0\0\0007\0\1\0'\1\0\0:\1\n\0004\0\0\0007\0\v\0'\1\2\0:\1\f\0004\0\0\0007\0\1\0%\1\14\0:\1\r\0G\0\1\0\nabdgm\16tex_conceal\17conceallevel\awo\25vimtex_quickfix_mode\fzathura\23vimtex_view_method\bnvr\29vimtex_compiler_progname\30vimtex_latexmk_continuous\23vimtex_fold_manual\nlatex\15tex_flavor\6g\bvim\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex"
  },
  vimwiki = {
    config = { "\27LJ\1\2o\0\0\2\0\4\0\t4\0\0\0007\0\1\0%\1\2\0>\0\2\0014\0\0\0007\0\1\0%\1\3\0>\0\2\1G\0\1\0#let g:vimwiki_conceallevel = 2!let g:vimwiki_global_ext = 1\bcmd\bvim\0" },
    loaded = false,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimwiki"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: vim-slime
time([[Config for vim-slime]], true)
try_loadstring("\27LJ\1\2Z\0\0\2\0\5\0\t4\0\0\0007\0\1\0%\1\3\0:\1\2\0004\0\0\0007\0\1\0'\1\1\0:\1\4\0G\0\1\0\25slime_python_ipython\vneovim\17slime_target\6g\bvim\0", "config", "vim-slime")
time([[Config for vim-slime]], false)
-- Config for: gruvbox
time([[Config for gruvbox]], true)
try_loadstring("\27LJ\1\2*\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\15highlights\frequire\0", "config", "gruvbox")
time([[Config for gruvbox]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
try_loadstring("\27LJ\1\0022\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\23plugins.statusline\frequire\0", "config", "galaxyline.nvim")
time([[Config for galaxyline.nvim]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\1\2�\1\0\0\2\0\a\0\r4\0\0\0007\0\1\0003\1\3\0:\1\2\0004\0\0\0007\0\1\0%\1\5\0:\1\4\0004\0\0\0007\0\1\0)\1\2\0:\1\6\0G\0\1\0*indent_blankline_show_current_context\b│\20indentLine_char\1\3\0\0\vpython\blua\30indent_blankline_filetype\6g\bvim\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: vim-sneak
time([[Config for vim-sneak]], true)
try_loadstring("\27LJ\1\2�\2\0\0\5\0\14\0%4\0\0\0007\0\1\0%\1\2\0>\0\2\0014\0\0\0007\0\3\0007\0\4\0%\1\5\0%\2\6\0%\3\a\0002\4\0\0>\0\5\0014\0\0\0007\0\3\0007\0\4\0%\1\5\0%\2\b\0%\3\t\0002\4\0\0>\0\5\0014\0\0\0007\0\3\0007\0\4\0%\1\5\0%\2\n\0%\3\v\0002\4\0\0>\0\5\0014\0\0\0007\0\3\0007\0\4\0%\1\5\0%\2\f\0%\3\r\0002\4\0\0>\0\5\1G\0\1\0\18<Plug>Sneak_T\6T\18<Plug>Sneak_t\6t\18<Plug>Sneak_F\6F\18<Plug>Sneak_f\6f\5\20nvim_set_keymap\bapi\26let g:sneak#label = 1\bcmd\bvim\0", "config", "vim-sneak")
time([[Config for vim-sneak]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
try_loadstring("\27LJ\1\0021\0\0\2\0\2\0\0044\0\0\0%\1\1\0>\0\2\1G\0\1\0\22plugins.telescope\frequire\0", "config", "telescope.nvim")
time([[Config for telescope.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-bufferline.lua ]]

-- Config for: nvim-bufferline.lua
try_loadstring("\27LJ\1\2�\1\0\0\3\0\6\0\t4\0\0\0%\1\1\0>\0\2\0027\0\2\0003\1\4\0003\2\3\0:\2\5\1>\0\2\1G\0\1\0\foptions\1\0\0\1\0\b\17number_style\16superscript\fnumbers\fordinal\28show_buffer_close_icons\1\20separator_style\tthin\tview\16multiwindow\rtab_size\3\18\rmappings\2\25enforce_regular_tabs\2\nsetup\15bufferline\frequire\0", "config", "nvim-bufferline.lua")

vim.cmd [[ packadd hop.nvim ]]

-- Config for: hop.nvim
try_loadstring("\27LJ\1\2�\5\0\0\v\0\29\0T4\0\0\0002\1\3\0004\2\1\0;\2\1\0014\2\2\0;\2\2\1>\0\2\4D\3 �\16\5\4\0003\6\3\0004\a\4\0%\b\5\0>\a\2\0027\a\6\a;\a\2\6>\5\2\1\16\5\4\0003\6\a\0004\a\4\0%\b\5\0>\a\2\0027\a\b\a;\a\2\6>\5\2\1\16\5\4\0003\6\t\0004\a\4\0%\b\5\0>\a\2\0027\a\n\a;\a\2\6>\5\2\1\16\5\4\0003\6\v\0004\a\4\0%\b\5\0>\a\2\0027\a\f\a;\a\2\6>\5\2\1B\3\3\3N\3�4\0\4\0%\1\r\0>\0\2\0024\1\4\0%\2\14\0>\1\2\0022\2\5\0003\3\15\0003\4\17\0007\5\16\0:\5\18\4;\4\2\3;\3\1\0023\3\19\0003\4\21\0007\5\20\0:\5\18\4;\4\2\3;\3\2\0023\3\22\0003\4\24\0007\5\23\0:\5\18\4;\4\2\3;\3\3\0023\3\25\0003\4\27\0007\5\26\0:\5\18\4;\4\2\3;\3\4\0024\3\0\0\16\4\2\0>\3\2\4D\6\4�7\b\28\0018\t\1\a8\n\2\a>\b\3\1B\6\3\3N\6�G\0\1\0\vset_hl\1\0\0\vlight4\1\2\0\0\17HopUnmatched\1\0\0\18neutral_green\1\2\0\0\16HopNextKey2\1\0\1\bgui\19bold,underline\17bright_green\1\2\0\0\16HopNextKey1\afg\1\0\1\bgui\19bold,underline\18bright_orange\1\2\0\0\15HopNextKey\nutils\23highlights.gruvbox\18hint_patterns\1\2\0\0\n<C-/>\15hint_lines\1\2\0\0\n<C-l>\15hint_char1\1\2\0\0\n<C-f>\15hint_char2\bhop\frequire\1\2\0\0\n<C-s>\rvnoremap\rnnoremap\npairs\0", "config", "hop.nvim")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
vim.cmd [[command! -nargs=* -range -bang -complete=file MarkdownPreview lua require("packer.load")({'markdown-preview.nvim'}, { cmd = "MarkdownPreview", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
vim.cmd [[command! -nargs=* -range -bang -complete=file Git lua require("packer.load")({'vim-fugitive'}, { cmd = "Git", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args> }, _G.packer_plugins)]]
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <A-m> <cmd>lua require("packer.load")({'nvim-tree'}, { keys = "<lt>A-m>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-q> <cmd>lua require("packer.load")({'nvim-bqf'}, { keys = "<lt>C-q>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> / <cmd>lua require("packer.load")({'vim-cool'}, { keys = "/", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <A-n> <cmd>lua require("packer.load")({'neogit'}, { keys = "<lt>A-n>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <space><space>zrg <cmd>lua require("packer.load")({'fzf.vim'}, { keys = "<lt>space><lt>space>zrg", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> gc <cmd>lua require("packer.load")({'vim-commentary'}, { keys = "gc", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType lua ++once lua require("packer.load")({'nvim-dap', 'nvim-lspconfig', 'vim-doge', 'nvim-colorizer.lua'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType python ++once lua require("packer.load")({'nvim-dap', 'nvim-lspconfig', 'vim-doge', 'nvim-dap-python'}, { ft = "python" }, _G.packer_plugins)]]
vim.cmd [[au FileType csv ++once lua require("packer.load")({'csv.vim'}, { ft = "csv" }, _G.packer_plugins)]]
vim.cmd [[au FileType markdown ++once lua require("packer.load")({'vimwiki', 'markdown-preview.nvim'}, { ft = "markdown" }, _G.packer_plugins)]]
vim.cmd [[au FileType tex ++once lua require("packer.load")({'vimtex'}, { ft = "tex" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'gitsigns.nvim'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-compe', 'vim-surround', 'vim-repeat'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
vim.cmd [[au CursorMoved * ++once lua require("packer.load")({'FixCursorHold.nvim'}, { event = "CursorMoved *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]], true)
vim.cmd [[source /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/csv.vim/ftdetect/csv.vim]], false)
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], true)
vim.cmd [[source /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]]
time([[Sourcing ftdetect script at: /home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex/ftdetect/tex.vim]], false)
vim.cmd("augroup END")
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry