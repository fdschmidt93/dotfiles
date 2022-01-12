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
    config = { "\27LJ\2\0027\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1ô\1=\1\2\0K\0\1\0\26cursorhold_updatetime\6g\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/FixCursorHold.nvim",
    url = "https://github.com/antoinemadec/FixCursorHold.nvim"
  },
  LuaSnip = {
    config = { "\27LJ\2\2ó\1\0\0\a\0\v\1\0216\0\0\0'\1\1\0B\0\2\2'\1\2\0005\2\t\0004\3\3\0009\4\4\0009\4\5\4'\5\6\0\18\6\1\0B\4\3\2>\4\1\0039\4\4\0009\4\5\4'\5\a\0'\6\b\0B\4\3\0?\4\0\0=\3\n\2=\2\3\0K\0\1\0\ball\1\0\0>Wow! This ${1:Stuff} really ${2:works. ${3:Well, a bit.}}\vlspsyn\bcod\18parse_snippet\vparser\rsnippets\28@code ${1}\n  ${2}\n@end\n\fluasnip\frequire\5€€À™\4\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ["astronauta.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/astronauta.nvim",
    url = "https://github.com/tjdevries/astronauta.nvim"
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
  ["filetype.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/filetype.nvim",
    url = "https://github.com/nathom/filetype.nvim"
  },
  firenvim = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/firenvim",
    url = "https://github.com/glacambre/firenvim"
  },
  ["fzf.vim"] = {
    config = { "\27LJ\2\2U\0\0\3\0\3\0\0066\0\0\0005\1\1\0005\2\2\0>\2\3\1B\0\2\1K\0\1\0\1\0\1\vsilent\2\1\3\0\0\22<space><space>zrg\16<cmd>Rg<CR>\rnnoremap\0" },
    keys = { { "", "<space><space>zrg" } },
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["galaxyline.nvim"] = {
    config = {},
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/galaxyline.nvim",
    url = "https://github.com/NTBBloodbath/galaxyline.nvim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\0026\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire)\1\0\2\0\3\0\0056\0\0\0009\0\1\0003\1\2\0B\0\2\1K\0\1\0\0\rschedule\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  gruvbox = {
    after = { "lightspeed.nvim", "nvim-bufferline.lua", "nvim-cmp" },
    loaded = true,
    only_config = true
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["indent-blankline.nvim"] = {
    config = { "\27LJ\2\2q\0\0\2\0\5\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0K\0\1\0*indent_blankline_show_current_context\bâ”‚\26indent_blankline_char\6g\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/indent-blankline.nvim",
    url = "https://github.com/lukas-reineke/indent-blankline.nvim"
  },
  ["lightspeed.nvim"] = {
    config = { "\27LJ\2\2â\2\0\0\5\0\16\00016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\4\0'\3\5\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\6\0'\3\a\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\b\0'\3\t\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\n\0'\3\v\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\f\0'\3\r\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\14\0'\3\15\0004\4\0\0B\0\5\1K\0\1\0\23<Plug>Lightspeed_T\6T\23<Plug>Lightspeed_t\6t\23<Plug>Lightspeed_F\6F\23<Plug>Lightspeed_f\6f\23<Plug>Lightspeed_S\6S\23<Plug>Lightspeed_s\6s\5\20nvim_set_keymap\bapi\bvim\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/lightspeed.nvim",
    url = "https://github.com/ggandor/lightspeed.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim",
    url = "https://github.com/ray-x/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
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
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim",
    url = "https://github.com/iamcco/markdown-preview.nvim"
  },
  neogit = {
    config = { "\27LJ\2\2ø\1\0\0\4\0\17\0\0226\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\4\0005\2\3\0=\2\5\0015\2\a\0005\3\6\0=\3\b\0025\3\t\0=\3\n\0025\3\v\0=\3\f\2=\2\r\1B\0\2\0016\0\14\0005\1\15\0005\2\16\0>\2\3\1B\0\2\1K\0\1\0\1\0\1\vsilent\2\1\3\0\0\n<A-n>\20<cmd>Neogit<CR>\rnnoremap\nsigns\thunk\1\3\0\0\bï¤”\bï¡³\titem\1\3\0\0\bâ–¸\bâ–¾\fsection\1\0\0\1\3\0\0\5\5\17integrations\1\0\0\1\0\1\rdiffview\2\nsetup\vneogit\frequire\0" },
    keys = { { "", "<A-n>" } },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/neogit",
    url = "https://github.com/TimUntersberger/neogit"
  },
  neorg = {
    config = { "\27LJ\2\2À\5\0\0\t\0'\00086\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\0025\1\a\0005\2\4\0005\3\5\0=\3\6\2=\2\b\1=\1\3\0006\1\0\0'\2\t\0B\1\2\0029\1\n\0015\2%\0005\3\v\0004\4\0\0=\4\f\0035\4\14\0005\5\r\0=\5\15\4=\4\16\0034\4\0\0=\4\17\0035\4\19\0005\5\18\0=\5\15\4=\4\20\0034\4\0\0=\4\21\0035\4 \0005\5\30\0005\6\26\0006\a\22\0009\a\23\a9\a\24\a'\b\25\0&\a\b\a=\a\27\0066\a\22\0009\a\23\a9\a\24\a'\b\28\0&\a\b\a=\a\29\6=\6\31\5=\5\15\4=\4!\0035\4#\0005\5\"\0=\5\15\4=\4$\3=\3&\2B\1\2\1K\0\1\0\tload\1\0\0\18core.gtd.base\1\0\0\1\0\1\14workspace\bgtd\21core.norg.dirman\1\0\0\15workspaces\1\0\0\bgtd\t/gtd\tmain\1\0\0\v/neorg\tHOME\benv\bvim\24core.norg.concealer\25core.norg.completion\1\0\0\1\0\1\vengine\rnvim-cmp core.integrations.telescope\18core.keybinds\vconfig\1\0\0\1\0\2\17neorg_leader\14<Leader>o\21default_keybinds\2\18core.defaults\1\0\0\nsetup\nneorg\17install_info\1\0\0\nfiles\1\3\0\0\17src/parser.c\19src/scanner.cc\1\0\2\vbranch\tmain\burl/https://github.com/vhyrro/tree-sitter-norg\tnorg\23get_parser_configs\28nvim-treesitter.parsers\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/neorg",
    url = "/home/fdschmidt/repos/lua/neorg"
  },
  ["neorg-telescope"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/neorg-telescope",
    url = "https://github.com/nvim-neorg/neorg-telescope"
  },
  ["nui.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nui.nvim",
    url = "https://github.com/MunifTanjim/nui.nvim"
  },
  ["null-ls.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-bqf"] = {
    config = { "\27LJ\2\2i\0\0\4\0\6\0\v6\0\0\0005\1\1\0006\2\2\0'\3\3\0B\2\2\0029\2\4\2>\2\2\0015\2\5\0>\2\3\1B\0\2\1K\0\1\0\1\0\1\vsilent\2\14toggle_qf\nutils\frequire\1\2\0\0\n<C-q>\rnnoremap\0" },
    keys = { { "", "<C-q>" } },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-bqf",
    url = "https://github.com/kevinhwang91/nvim-bqf"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\2!\0\1\3\0\2\0\0039\1\0\0009\2\1\0D\1\2\0\fordinal\nraiseå\2\1\0\t\0\14\0\"6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\6\0005\2\3\0003\3\4\0=\3\5\2=\2\a\1B\0\2\1)\0\1\0)\1\t\0)\2\1\0M\0\19€6\4\b\0\18\5\3\0B\4\2\2\18\3\4\0006\4\t\0004\5\4\0'\6\n\0\18\a\3\0&\6\a\6>\6\1\5'\6\v\0\18\a\3\0'\b\f\0&\6\b\6>\6\2\0055\6\r\0>\6\3\5B\4\2\1O\0íK\0\1\0\1\0\1\vsilent\2\t<CR>\31<cmd>BufferLineGoToBuffer \r<leader>\rnnoremap\rtostring\foptions\1\0\0\fnumbers\0\1\0\5\rtab_size\3\18\25enforce_regular_tabs\2\tview\16multiwindow\28show_buffer_close_icons\1\20separator_style\tthin\nsetup\15bufferline\frequire\0" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua",
    url = "https://github.com/akinsho/nvim-bufferline.lua"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\2-\0\1\3\1\2\0\5-\1\0\0009\1\0\0019\2\1\0B\1\2\1K\0\1\0\1À\tbody\15lsp_expand¡\2\0\1\a\1\v\1*6\1\0\0009\1\1\0019\1\2\1B\1\1\2\t\1\0\0X\1\14€6\1\0\0009\1\1\0019\1\3\0016\2\0\0009\2\4\0029\2\5\2'\3\6\0+\4\2\0+\5\2\0+\6\2\0B\2\5\2'\3\a\0B\1\3\1X\1\21€-\1\0\0009\1\b\1B\1\1\2\15\0\1\0X\2\14€6\1\0\0009\1\1\0019\1\3\0016\2\0\0009\2\4\0029\2\5\2'\3\t\0+\4\2\0+\5\2\0+\6\2\0B\2\5\2'\3\n\0B\1\3\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\1À\5!<Plug>luasnip-expand-or-jump\23expand_or_jumpable\6n\n<C-n>\27nvim_replace_termcodes\bapi\rfeedkeys\15pumvisible\afn\bvim\2–\2\0\1\a\1\v\1+6\1\0\0009\1\1\0019\1\2\1B\1\1\2\t\1\0\0X\1\14€6\1\0\0009\1\1\0019\1\3\0016\2\0\0009\2\4\0029\2\5\2'\3\6\0+\4\2\0+\5\2\0+\6\2\0B\2\5\2'\3\a\0B\1\3\1X\1\22€-\1\0\0009\1\b\1)\2ÿÿB\1\2\2\15\0\1\0X\2\14€6\1\0\0009\1\1\0019\1\3\0016\2\0\0009\2\4\0029\2\5\2'\3\t\0+\4\2\0+\5\2\0+\6\2\0B\2\5\2'\3\n\0B\1\3\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\1À\5\28<Plug>luasnip-jump-prev\rjumpable\6n\n<C-p>\27nvim_replace_termcodes\bapi\rfeedkeys\15pumvisible\afn\bvim\2È\t\1\0\t\0>\1f6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\4\0'\1\5\0B\0\2\0026\1\4\0'\2\6\0B\1\2\0026\2\4\0'\3\a\0B\2\2\0029\3\b\0005\4\n\0005\5\t\0=\5\v\0049\5\f\0025\6\14\0005\a\r\0=\a\15\6B\5\2\2=\5\16\0045\5\18\0003\6\17\0=\6\19\5=\5\20\0045\5\22\0005\6\21\0=\6\23\5=\5\24\0045\5\25\0006\6\26\0009\6\27\0066\a\0\0009\a\1\a9\a\28\a\24\a\0\aB\6\2\2=\6\29\5=\5\30\0044\5\a\0005\6\31\0>\6\1\0055\6 \0>\6\2\0055\6!\0>\6\3\0055\6\"\0>\6\4\0055\6#\0>\6\5\0055\6$\0>\6\6\5=\5%\0045\5(\0009\6&\0009\6'\6B\6\1\2=\6)\0059\6&\0009\6*\6B\6\1\2=\6+\0059\6&\0009\6,\6)\a\4\0B\6\2\2=\6-\0059\6&\0009\6,\6)\aüÿB\6\2\2=\6.\0059\6&\0009\6/\6B\6\1\2=\0060\0059\6&\0009\0061\6B\6\1\2=\0062\0059\6&\0009\0061\6B\6\1\2=\0063\0059\6&\0009\0064\0065\a7\0009\b5\0009\b6\b=\b8\aB\6\2\2=\0069\0053\6:\0=\6;\0053\6<\0=\6=\5=\5&\4B\3\2\0012\0\0€K\0\1\0\f<S-Tab>\0\n<Tab>\0\t<CR>\rbehavior\1\0\1\vselect\1\fReplace\20ConfirmBehavior\fconfirm\n<ESC>\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\fsources\1\0\1\tname\arg\1\0\1\tname\nneorg\1\0\1\tname\fluasnip\1\0\1\tname\vbuffer\1\0\1\tname\tpath\1\0\1\tname\rnvim_lsp\18documentation\15max_height\nlines\nfloor\tmath\1\0\5\17winhighlightHNormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder\15min_height\3\1\14min_width\3<\14max_width\3x\vborder\frounded\15completion\17autocomplete\1\0\1\16completeopt\21menuone,noselect\1\4\0\0\16InsertEnter\16TextChanged\17TextChangedI\fsnippet\vexpand\1\0\0\0\vformat\tmenu\1\0\0\1\0\6\fluasnip\v[snip]\rnvim_lua\n[api]\rnvim_lsp\n[LSP]\vbuffer\n[buf]\arg\t[rg]\tpath\v[path]\15cmp_format\17experimental\1\0\0\1\0\2\16native_menu\1\15ghost_text\2\nsetup\flspkind\fluasnip\bcmp\frequire\21menuone,noselect\16completeopt\6o\bvimçÌ™³\6³æÌþ\3\0" },
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
    config = { "\27LJ\2\2\5\0\0\5\0\28\0T5\0\0\0006\1\1\0005\2\2\0006\3\3\0'\4\4\0B\3\2\0029\3\5\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\6\0006\3\3\0'\4\4\0B\3\2\0029\3\a\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\b\0006\3\3\0'\4\4\0B\3\2\0029\3\t\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\n\0006\3\3\0'\4\4\0B\3\2\0029\3\v\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\f\0006\3\3\0'\4\4\0B\3\2\0029\3\r\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\14\0006\3\3\0'\4\4\0B\3\2\0029\3\15\0039\3\16\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\17\0006\3\3\0'\4\4\0B\3\2\0029\3\18\3>\3\2\2>\0\3\2B\1\2\0016\1\19\0009\1\20\0019\1\21\1'\2\22\0005\3\23\0B\1\3\0016\1\19\0009\1\20\0019\1\21\1'\2\24\0005\3\25\0B\1\3\0016\1\3\0'\2\26\0B\1\2\0029\1\27\1'\2\4\0B\1\2\1K\0\1\0\19load_extension\14telescope\1\0\2\ttext\bï„¸\vtexthl\fStopped\15DapStopped\1\0\2\ttext\bï„‘\vtexthl\15Breakpoint\18DapBreakpoint\16sign_define\afn\bvim\rrun_last\1\2\0\0\14<space>dl\topen\trepl\1\2\0\0\14<space>dr\22toggle_breakpoint\1\2\0\0\r<space>b\rstep_out\1\2\0\0\n<F12>\14step_into\1\2\0\0\n<F11>\14step_over\1\2\0\0\n<F10>\rcontinue\bdap\frequire\1\2\0\0\t<F5>\rnnoremap\1\0\1\vsilent\2\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-dap",
    url = "https://github.com/mfussenegger/nvim-dap"
  },
  ["nvim-dap-python"] = {
    config = { "\27LJ\2\2’\1\0\0\3\0\t\0\0146\0\0\0009\0\1\0'\1\2\0006\2\3\0009\2\4\0029\2\5\2B\0\3\0026\1\6\0'\2\a\0B\1\2\0029\1\b\1\18\2\0\0B\1\2\1K\0\1\0\nsetup\15dap-python\frequire\tUSER\benv\bvim#/home/%s/miniconda3/bin/python\vformat\vstring\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-dap-python",
    url = "https://github.com/mfussenegger/nvim-dap-python"
  },
  ["nvim-dap-ui"] = {
    config = { "\27LJ\2\0023\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ndapui\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-dap-ui",
    url = "https://github.com/rcarriga/nvim-dap-ui"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\0025\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\26fds.plugins.lspconfig\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree"] = {
    config = { "\27LJ\2\2µ\1\0\0\3\0\a\0\0146\0\0\0005\1\1\0005\2\2\0>\2\3\1B\0\2\0016\0\3\0009\0\4\0)\1\1\0=\1\5\0006\0\3\0009\0\4\0)\1\1\0=\1\6\0K\0\1\0%nvim_tree_highlight_opened_files\29nvim_tree_indent_markers\6g\bvim\1\0\1\vsilent\2\1\3\0\0\n<A-m>\28<cmd>NvimTreeToggle<CR>\rnnoremap\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/nvim-tree",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    after = { "neorg" },
    loaded = true,
    only_config = true
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
  ["renamer.nvim"] = {
    config = { "\27LJ\2\0025\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\frenamer\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/renamer.nvim",
    url = "https://github.com/filipdutescu/renamer.nvim"
  },
  ["rust-tools.nvim"] = {
    config = { "\27LJ\2\2<\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\15rust-tools\frequire\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/rust-tools.nvim",
    url = "https://github.com/simrat39/rust-tools.nvim"
  },
  ["sqlite.lua"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/sqlite.lua",
    url = "https://github.com/tami5/sqlite.lua"
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
  ["telescope-frecency.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-frecency.nvim",
    url = "https://github.com/nvim-telescope/telescope-frecency.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope-fzf-writer.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-fzf-writer.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-writer.nvim"
  },
  ["telescope-hop.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-hop.nvim",
    url = "/home/fdschmidt/repos/lua/telescope-hop.nvim"
  },
  ["telescope-live-grep-raw.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-live-grep-raw.nvim",
    url = "https://github.com/nvim-telescope/telescope-live-grep-raw.nvim"
  },
  ["telescope-project.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-project.nvim",
    url = "https://github.com/nvim-telescope/telescope-project.nvim"
  },
  ["telescope-smart-history.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-smart-history.nvim",
    url = "https://github.com/nvim-telescope/telescope-smart-history.nvim"
  },
  ["telescope-ui-select.nvim"] = {
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/telescope-ui-select.nvim",
    url = "/home/fdschmidt/repos/lua/telescope-ui-select.nvim"
  },
  ["telescope.nvim"] = {
    config = {},
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
    commands = { "Git" },
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
  ["vim-slime"] = {
    config = { "\27LJ\2\2Z\0\0\2\0\5\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0K\0\1\0\25slime_python_ipython\vneovim\17slime_target\6g\bvim\0" },
    loaded = true,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/start/vim-slime",
    url = "https://github.com/jpalardy/vim-slime"
  },
  ["vim-surround"] = {
    loaded = false,
    needs_bufread = false,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  vimtex = {
    config = { "\27LJ\2\2¾\2\0\0\2\0\15\0!6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0006\0\0\0009\0\1\0)\1\1\0=\1\5\0006\0\0\0009\0\1\0'\1\a\0=\1\6\0006\0\0\0009\0\1\0'\1\t\0=\1\b\0006\0\0\0009\0\1\0)\1\0\0=\1\n\0006\0\0\0009\0\v\0)\1\2\0=\1\f\0006\0\0\0009\0\1\0'\1\14\0=\1\r\0K\0\1\0\nabdgm\16tex_conceal\17conceallevel\awo\25vimtex_quickfix_mode\fzathura\23vimtex_view_method\bnvr\29vimtex_compiler_progname\30vimtex_latexmk_continuous\23vimtex_fold_manual\nlatex\15tex_flavor\6g\bvim\0" },
    loaded = false,
    needs_bufread = true,
    only_cond = false,
    path = "/home/fdschmidt/.local/share/nvim/site/pack/packer/opt/vimtex",
    url = "https://github.com/lervag/vimtex"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: FixCursorHold.nvim
time([[Config for FixCursorHold.nvim]], true)
try_loadstring("\27LJ\2\0027\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1ô\1=\1\2\0K\0\1\0\26cursorhold_updatetime\6g\bvim\0", "config", "FixCursorHold.nvim")
time([[Config for FixCursorHold.nvim]], false)
-- Config for: vim-slime
time([[Config for vim-slime]], true)
try_loadstring("\27LJ\2\2Z\0\0\2\0\5\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0)\1\1\0=\1\4\0K\0\1\0\25slime_python_ipython\vneovim\17slime_target\6g\bvim\0", "config", "vim-slime")
time([[Config for vim-slime]], false)
-- Config for: gruvbox
time([[Config for gruvbox]], true)
try_loadstring("\27LJ\2\2.\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\19fds.highlights\frequire\0", "config", "gruvbox")
time([[Config for gruvbox]], false)
-- Config for: indent-blankline.nvim
time([[Config for indent-blankline.nvim]], true)
try_loadstring("\27LJ\2\2q\0\0\2\0\5\0\t6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\0\0009\0\1\0+\1\2\0=\1\4\0K\0\1\0*indent_blankline_show_current_context\bâ”‚\26indent_blankline_char\6g\bvim\0", "config", "indent-blankline.nvim")
time([[Config for indent-blankline.nvim]], false)
-- Config for: nvim-dap
time([[Config for nvim-dap]], true)
try_loadstring("\27LJ\2\2\5\0\0\5\0\28\0T5\0\0\0006\1\1\0005\2\2\0006\3\3\0'\4\4\0B\3\2\0029\3\5\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\6\0006\3\3\0'\4\4\0B\3\2\0029\3\a\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\b\0006\3\3\0'\4\4\0B\3\2\0029\3\t\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\n\0006\3\3\0'\4\4\0B\3\2\0029\3\v\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\f\0006\3\3\0'\4\4\0B\3\2\0029\3\r\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\14\0006\3\3\0'\4\4\0B\3\2\0029\3\15\0039\3\16\3>\3\2\2>\0\3\2B\1\2\0016\1\1\0005\2\17\0006\3\3\0'\4\4\0B\3\2\0029\3\18\3>\3\2\2>\0\3\2B\1\2\0016\1\19\0009\1\20\0019\1\21\1'\2\22\0005\3\23\0B\1\3\0016\1\19\0009\1\20\0019\1\21\1'\2\24\0005\3\25\0B\1\3\0016\1\3\0'\2\26\0B\1\2\0029\1\27\1'\2\4\0B\1\2\1K\0\1\0\19load_extension\14telescope\1\0\2\ttext\bï„¸\vtexthl\fStopped\15DapStopped\1\0\2\ttext\bï„‘\vtexthl\15Breakpoint\18DapBreakpoint\16sign_define\afn\bvim\rrun_last\1\2\0\0\14<space>dl\topen\trepl\1\2\0\0\14<space>dr\22toggle_breakpoint\1\2\0\0\r<space>b\rstep_out\1\2\0\0\n<F12>\14step_into\1\2\0\0\n<F11>\14step_over\1\2\0\0\n<F10>\rcontinue\bdap\frequire\1\2\0\0\t<F5>\rnnoremap\1\0\1\vsilent\2\0", "config", "nvim-dap")
time([[Config for nvim-dap]], false)
-- Config for: rust-tools.nvim
time([[Config for rust-tools.nvim]], true)
try_loadstring("\27LJ\2\2<\0\0\2\0\3\0\a6\0\0\0'\1\1\0B\0\2\0029\0\2\0004\1\0\0B\0\2\1K\0\1\0\nsetup\15rust-tools\frequire\0", "config", "rust-tools.nvim")
time([[Config for rust-tools.nvim]], false)
-- Config for: nvim-dap-ui
time([[Config for nvim-dap-ui]], true)
try_loadstring("\27LJ\2\0023\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\ndapui\frequire\0", "config", "nvim-dap-ui")
time([[Config for nvim-dap-ui]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\0026\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\27fds.plugins.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\2ó\1\0\0\a\0\v\1\0216\0\0\0'\1\1\0B\0\2\2'\1\2\0005\2\t\0004\3\3\0009\4\4\0009\4\5\4'\5\6\0\18\6\1\0B\4\3\2>\4\1\0039\4\4\0009\4\5\4'\5\a\0'\6\b\0B\4\3\0?\4\0\0=\3\n\2=\2\3\0K\0\1\0\ball\1\0\0>Wow! This ${1:Stuff} really ${2:works. ${3:Well, a bit.}}\vlspsyn\bcod\18parse_snippet\vparser\rsnippets\28@code ${1}\n  ${2}\n@end\n\fluasnip\frequire\5€€À™\4\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: nvim-dap-python
time([[Config for nvim-dap-python]], true)
try_loadstring("\27LJ\2\2’\1\0\0\3\0\t\0\0146\0\0\0009\0\1\0'\1\2\0006\2\3\0009\2\4\0029\2\5\2B\0\3\0026\1\6\0'\2\a\0B\1\2\0029\1\b\1\18\2\0\0B\1\2\1K\0\1\0\nsetup\15dap-python\frequire\tUSER\benv\bvim#/home/%s/miniconda3/bin/python\vformat\vstring\0", "config", "nvim-dap-python")
time([[Config for nvim-dap-python]], false)
-- Config for: vim-doge
time([[Config for vim-doge]], true)
try_loadstring("\27LJ\2\2f\0\0\2\0\5\0\t6\0\0\0009\0\1\0)\1\1\0=\1\2\0006\0\0\0009\0\1\0'\1\4\0=\1\3\0K\0\1\0\vgoogle\29doge_doc_standard_python\25doge_enable_mappings\6g\bvim\0", "config", "vim-doge")
time([[Config for vim-doge]], false)
-- Config for: nvim-lspconfig
time([[Config for nvim-lspconfig]], true)
try_loadstring("\27LJ\2\0025\0\0\2\0\2\0\0046\0\0\0'\1\1\0B\0\2\1K\0\1\0\26fds.plugins.lspconfig\frequire\0", "config", "nvim-lspconfig")
time([[Config for nvim-lspconfig]], false)
-- Config for: nvim-tree
time([[Config for nvim-tree]], true)
try_loadstring("\27LJ\2\2µ\1\0\0\3\0\a\0\0146\0\0\0005\1\1\0005\2\2\0>\2\3\1B\0\2\0016\0\3\0009\0\4\0)\1\1\0=\1\5\0006\0\3\0009\0\4\0)\1\1\0=\1\6\0K\0\1\0%nvim_tree_highlight_opened_files\29nvim_tree_indent_markers\6g\bvim\1\0\1\vsilent\2\1\3\0\0\n<A-m>\28<cmd>NvimTreeToggle<CR>\rnnoremap\0", "config", "nvim-tree")
time([[Config for nvim-tree]], false)
-- Config for: galaxyline.nvim
time([[Config for galaxyline.nvim]], true)
time([[Config for galaxyline.nvim]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\0026\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire)\1\0\2\0\3\0\0056\0\0\0009\0\1\0003\1\2\0B\0\2\1K\0\1\0\0\rschedule\bvim\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: Comment.nvim
time([[Config for Comment.nvim]], true)
try_loadstring("\27LJ\2\0025\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\fComment\frequire\0", "config", "Comment.nvim")
time([[Config for Comment.nvim]], false)
-- Config for: renamer.nvim
time([[Config for renamer.nvim]], true)
try_loadstring("\27LJ\2\0025\0\0\2\0\3\0\0066\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\frenamer\frequire\0", "config", "renamer.nvim")
time([[Config for renamer.nvim]], false)
-- Config for: telescope.nvim
time([[Config for telescope.nvim]], true)
time([[Config for telescope.nvim]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd nvim-bufferline.lua ]]

-- Config for: nvim-bufferline.lua
try_loadstring("\27LJ\2\2!\0\1\3\0\2\0\0039\1\0\0009\2\1\0D\1\2\0\fordinal\nraiseå\2\1\0\t\0\14\0\"6\0\0\0'\1\1\0B\0\2\0029\0\2\0005\1\6\0005\2\3\0003\3\4\0=\3\5\2=\2\a\1B\0\2\1)\0\1\0)\1\t\0)\2\1\0M\0\19€6\4\b\0\18\5\3\0B\4\2\2\18\3\4\0006\4\t\0004\5\4\0'\6\n\0\18\a\3\0&\6\a\6>\6\1\5'\6\v\0\18\a\3\0'\b\f\0&\6\b\6>\6\2\0055\6\r\0>\6\3\5B\4\2\1O\0íK\0\1\0\1\0\1\vsilent\2\t<CR>\31<cmd>BufferLineGoToBuffer \r<leader>\rnnoremap\rtostring\foptions\1\0\0\fnumbers\0\1\0\5\rtab_size\3\18\25enforce_regular_tabs\2\tview\16multiwindow\28show_buffer_close_icons\1\20separator_style\tthin\nsetup\15bufferline\frequire\0", "config", "nvim-bufferline.lua")

vim.cmd [[ packadd lightspeed.nvim ]]

-- Config for: lightspeed.nvim
try_loadstring("\27LJ\2\2â\2\0\0\5\0\16\00016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\4\0'\3\5\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\6\0'\3\a\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\b\0'\3\t\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\n\0'\3\v\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\f\0'\3\r\0004\4\0\0B\0\5\0016\0\0\0009\0\1\0009\0\2\0'\1\3\0'\2\14\0'\3\15\0004\4\0\0B\0\5\1K\0\1\0\23<Plug>Lightspeed_T\6T\23<Plug>Lightspeed_t\6t\23<Plug>Lightspeed_F\6F\23<Plug>Lightspeed_f\6f\23<Plug>Lightspeed_S\6S\23<Plug>Lightspeed_s\6s\5\20nvim_set_keymap\bapi\bvim\0", "config", "lightspeed.nvim")

vim.cmd [[ packadd nvim-cmp ]]

-- Config for: nvim-cmp
try_loadstring("\27LJ\2\2-\0\1\3\1\2\0\5-\1\0\0009\1\0\0019\2\1\0B\1\2\1K\0\1\0\1À\tbody\15lsp_expand¡\2\0\1\a\1\v\1*6\1\0\0009\1\1\0019\1\2\1B\1\1\2\t\1\0\0X\1\14€6\1\0\0009\1\1\0019\1\3\0016\2\0\0009\2\4\0029\2\5\2'\3\6\0+\4\2\0+\5\2\0+\6\2\0B\2\5\2'\3\a\0B\1\3\1X\1\21€-\1\0\0009\1\b\1B\1\1\2\15\0\1\0X\2\14€6\1\0\0009\1\1\0019\1\3\0016\2\0\0009\2\4\0029\2\5\2'\3\t\0+\4\2\0+\5\2\0+\6\2\0B\2\5\2'\3\n\0B\1\3\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\1À\5!<Plug>luasnip-expand-or-jump\23expand_or_jumpable\6n\n<C-n>\27nvim_replace_termcodes\bapi\rfeedkeys\15pumvisible\afn\bvim\2–\2\0\1\a\1\v\1+6\1\0\0009\1\1\0019\1\2\1B\1\1\2\t\1\0\0X\1\14€6\1\0\0009\1\1\0019\1\3\0016\2\0\0009\2\4\0029\2\5\2'\3\6\0+\4\2\0+\5\2\0+\6\2\0B\2\5\2'\3\a\0B\1\3\1X\1\22€-\1\0\0009\1\b\1)\2ÿÿB\1\2\2\15\0\1\0X\2\14€6\1\0\0009\1\1\0019\1\3\0016\2\0\0009\2\4\0029\2\5\2'\3\t\0+\4\2\0+\5\2\0+\6\2\0B\2\5\2'\3\n\0B\1\3\1X\1\2€\18\1\0\0B\1\1\1K\0\1\0\1À\5\28<Plug>luasnip-jump-prev\rjumpable\6n\n<C-p>\27nvim_replace_termcodes\bapi\rfeedkeys\15pumvisible\afn\bvim\2È\t\1\0\t\0>\1f6\0\0\0009\0\1\0'\1\3\0=\1\2\0006\0\4\0'\1\5\0B\0\2\0026\1\4\0'\2\6\0B\1\2\0026\2\4\0'\3\a\0B\2\2\0029\3\b\0005\4\n\0005\5\t\0=\5\v\0049\5\f\0025\6\14\0005\a\r\0=\a\15\6B\5\2\2=\5\16\0045\5\18\0003\6\17\0=\6\19\5=\5\20\0045\5\22\0005\6\21\0=\6\23\5=\5\24\0045\5\25\0006\6\26\0009\6\27\0066\a\0\0009\a\1\a9\a\28\a\24\a\0\aB\6\2\2=\6\29\5=\5\30\0044\5\a\0005\6\31\0>\6\1\0055\6 \0>\6\2\0055\6!\0>\6\3\0055\6\"\0>\6\4\0055\6#\0>\6\5\0055\6$\0>\6\6\5=\5%\0045\5(\0009\6&\0009\6'\6B\6\1\2=\6)\0059\6&\0009\6*\6B\6\1\2=\6+\0059\6&\0009\6,\6)\a\4\0B\6\2\2=\6-\0059\6&\0009\6,\6)\aüÿB\6\2\2=\6.\0059\6&\0009\6/\6B\6\1\2=\0060\0059\6&\0009\0061\6B\6\1\2=\0062\0059\6&\0009\0061\6B\6\1\2=\0063\0059\6&\0009\0064\0065\a7\0009\b5\0009\b6\b=\b8\aB\6\2\2=\0069\0053\6:\0=\6;\0053\6<\0=\6=\5=\5&\4B\3\2\0012\0\0€K\0\1\0\f<S-Tab>\0\n<Tab>\0\t<CR>\rbehavior\1\0\1\vselect\1\fReplace\20ConfirmBehavior\fconfirm\n<ESC>\n<C-e>\nclose\14<C-Space>\rcomplete\n<C-f>\n<C-d>\16scroll_docs\n<C-n>\21select_next_item\n<C-p>\1\0\0\21select_prev_item\fmapping\fsources\1\0\1\tname\arg\1\0\1\tname\nneorg\1\0\1\tname\fluasnip\1\0\1\tname\vbuffer\1\0\1\tname\tpath\1\0\1\tname\rnvim_lsp\18documentation\15max_height\nlines\nfloor\tmath\1\0\5\17winhighlightHNormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder\15min_height\3\1\14min_width\3<\14max_width\3x\vborder\frounded\15completion\17autocomplete\1\0\1\16completeopt\21menuone,noselect\1\4\0\0\16InsertEnter\16TextChanged\17TextChangedI\fsnippet\vexpand\1\0\0\0\vformat\tmenu\1\0\0\1\0\6\fluasnip\v[snip]\rnvim_lua\n[api]\rnvim_lsp\n[LSP]\vbuffer\n[buf]\arg\t[rg]\tpath\v[path]\15cmp_format\17experimental\1\0\0\1\0\2\16native_menu\1\15ghost_text\2\nsetup\flspkind\fluasnip\bcmp\frequire\21menuone,noselect\16completeopt\6o\bvimçÌ™³\6³æÌþ\3\0", "config", "nvim-cmp")

vim.cmd [[ packadd neorg ]]

-- Config for: neorg
try_loadstring("\27LJ\2\2À\5\0\0\t\0'\00086\0\0\0'\1\1\0B\0\2\0029\0\2\0B\0\1\0025\1\a\0005\2\4\0005\3\5\0=\3\6\2=\2\b\1=\1\3\0006\1\0\0'\2\t\0B\1\2\0029\1\n\0015\2%\0005\3\v\0004\4\0\0=\4\f\0035\4\14\0005\5\r\0=\5\15\4=\4\16\0034\4\0\0=\4\17\0035\4\19\0005\5\18\0=\5\15\4=\4\20\0034\4\0\0=\4\21\0035\4 \0005\5\30\0005\6\26\0006\a\22\0009\a\23\a9\a\24\a'\b\25\0&\a\b\a=\a\27\0066\a\22\0009\a\23\a9\a\24\a'\b\28\0&\a\b\a=\a\29\6=\6\31\5=\5\15\4=\4!\0035\4#\0005\5\"\0=\5\15\4=\4$\3=\3&\2B\1\2\1K\0\1\0\tload\1\0\0\18core.gtd.base\1\0\0\1\0\1\14workspace\bgtd\21core.norg.dirman\1\0\0\15workspaces\1\0\0\bgtd\t/gtd\tmain\1\0\0\v/neorg\tHOME\benv\bvim\24core.norg.concealer\25core.norg.completion\1\0\0\1\0\1\vengine\rnvim-cmp core.integrations.telescope\18core.keybinds\vconfig\1\0\0\1\0\2\17neorg_leader\14<Leader>o\21default_keybinds\2\18core.defaults\1\0\0\nsetup\nneorg\17install_info\1\0\0\nfiles\1\3\0\0\17src/parser.c\19src/scanner.cc\1\0\2\vbranch\tmain\burl/https://github.com/vhyrro/tree-sitter-norg\tnorg\23get_parser_configs\28nvim-treesitter.parsers\frequire\0", "config", "neorg")

time([[Sequenced loading]], false)

-- Command lazy-loads
time([[Defining lazy-load commands]], true)
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file TSPlaygroundToggle lua require("packer.load")({'playground'}, { cmd = "TSPlaygroundToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Git lua require("packer.load")({'vim-fugitive'}, { cmd = "Git", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
time([[Defining lazy-load commands]], false)

-- Keymap lazy-loads
time([[Defining lazy-load keymaps]], true)
vim.cmd [[noremap <silent> <A-n> <cmd>lua require("packer.load")({'neogit'}, { keys = "<lt>A-n>", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <space><space>zrg <cmd>lua require("packer.load")({'fzf.vim'}, { keys = "<lt>space><lt>space>zrg", prefix = "" }, _G.packer_plugins)<cr>]]
vim.cmd [[noremap <silent> <C-q> <cmd>lua require("packer.load")({'nvim-bqf'}, { keys = "<lt>C-q>", prefix = "" }, _G.packer_plugins)<cr>]]
time([[Defining lazy-load keymaps]], false)

vim.cmd [[augroup packer_load_aucmds]]
vim.cmd [[au!]]
  -- Filetype lazy-loads
time([[Defining lazy-load filetype autocommands]], true)
vim.cmd [[au FileType csv ++once lua require("packer.load")({'csv.vim'}, { ft = "csv" }, _G.packer_plugins)]]
vim.cmd [[au FileType lua ++once lua require("packer.load")({'nvim-colorizer.lua'}, { ft = "lua" }, _G.packer_plugins)]]
vim.cmd [[au FileType tex ++once lua require("packer.load")({'vimtex'}, { ft = "tex" }, _G.packer_plugins)]]
time([[Defining lazy-load filetype autocommands]], false)
  -- Event lazy-loads
time([[Defining lazy-load event autocommands]], true)
vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'vim-repeat', 'vim-surround'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
time([[Defining lazy-load event autocommands]], false)
vim.cmd("augroup END")
vim.cmd [[augroup filetypedetect]]
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
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
