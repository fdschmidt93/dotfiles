local opts_info = vim.api.nvim_get_all_options_info()

local opt = setmetatable({}, {
  __newindex = function(_, key, value)
    vim.o[key] = value
    local scope = opts_info[key].scope
    if scope == 'win' then
      vim.wo[key] = value
    elseif scope == 'buf' then
      vim.bo[key] = value
    end
  end
})

-- Incremental live completion
opt.inccommand = 'nosplit'

-- Change backspace to behave more intuitively
opt.backspace = [[indent,eol,start]]

opt.clipboard = [[unnamed,unnamedplus]]

-- Set indent options for vim
opt.wrap = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.textwidth = 80
opt.expandtab = true
opt.autoindent = true

opt.breakindent = true
opt.linebreak = true

-- Set highlight on search
opt.hlsearch = true
opt.incsearch = true
opt.smartcase = true
opt.ignorecase = true
opt.showbreak = [[↪ ]]

-- Do not save when switching buffers
opt.hidden = true

-- Enable mouse mode
opt.mouse = 'a'

-- Set show command
opt.showcmd = true
opt.showmode = false

opt.number = true
opt.relativenumber = true

opt.splitbelow = true -- New horizontal splits window below
opt.splitright = true -- New vertical splits window right

opt.scrolloff = 10 -- always 10 lines below/above cursor
opt.pumheight = 10

opt.cursorline = true
opt.termguicolors = true

vim.cmd [[let &fcs='eob: ']] -- hide end of buffer line markers
vim.cmd [[set fillchars+=vert:\|]]
