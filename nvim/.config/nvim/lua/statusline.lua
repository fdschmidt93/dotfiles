-- only load settings if module is available to avoid packer issues
-- if not loaded('galaxyline.nvim') then return end
local gl = require 'galaxyline'
local condition = require('galaxyline.condition')
local fileinfo = require('galaxyline.provider_fileinfo')
local gls = gl.section
local colors = require('colors.gruvbox')
local ts_utils = require('nvim-treesitter.ts_utils')
local parsers = require 'nvim-treesitter.parsers'
local lsp = vim.lsp
local api = vim.api

function firstToUpper(str) return (str:gsub("^%l", string.upper)) end

-- ensure inactive only shows short_line_{left, right}
gl.short_line_list = {" "}

local separators = {
  space = ' ',
  vertical_bar = '┃',
  vertical_bar_thin = '│',
  left = '',
  right = '',
  block = '█',
  left_filled = '',
  right_filled = '',
  slant_left = '',
  slant_left_thin = '',
  slant_right = '',
  slant_right_thin = '',
  slant_left_2 = '',
  slant_left_2_thin = '',
  slant_right_2 = '',
  slant_right_2_thin = '',
  left_rounded = '',
  left_rounded_thin = '',
  right_rounded = '',
  right_rounded_thin = '',
  circle = '●'
}

local alias = {
  r = 'replace',
  rv = 'virtual',
  [''] = 'select',
  [''] = 'visual',
  ['!'] = 'shell',
  ['r'] = 'hit-enter',
  ['r?'] = ':confirm',
  c = 'command',
  i = 'insert',
  ic = 'insert',
  n = 'normal',
  rm = '--more',
  s = 'select',
  t = 'terminal',
  v = 'visual',
  V = 'visual'
}
local mode_color = {
  r = colors.faded_yellow,
  rv = colors.faded_yellow,
  v = colors.faded_purple,
  [''] = colors.orange,
  [''] = colors.neutral_purple,
  ['!'] = colors.faded_green,
  ['r'] = colors.neutral_aqua,
  ['r?'] = colors.faded_aqua,
  c = colors.faded_green,
  cv = colors.red,
  ce = colors.red,
  i = colors.bright_blue,
  ic = colors.neutral_yellow,
  n = colors.bright_green,
  no = colors.magenta,
  rm = colors.bright_aqua,
  s = colors.orange,
  s = colors.orange,
  t = colors.neutral_green,
  V = colors.bright_purple
}

local function get_mode_color()
  local vim_mode = api.nvim_get_mode().mode
  return mode_color[vim_mode]
end

local function has_file_type()
  local f_type = vim.bo.filetype
  if not f_type or f_type == '' then return false end
  return true
end

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then return true end
  return false
end

local function git_condition()
  return condition.check_git_workspace() and buffer_not_empty() and
           has_file_type()
end

local function gitsigns(type, fmt)
  local status = vim.b['gitsigns_status_dict']
  if status ~= nil then
    local val = status[type]
    if val == 0 then return '' end
    if fmt ~= nil then return string.format(fmt, val) end
    return val
  end
  return ''
end

local function get_nvim_lsp_diagnostic(diag_type, icon)
  if next(lsp.buf_get_clients(0)) == nil then return '' end
  local active_clients = lsp.get_active_clients()

  if active_clients then
    local count = 0

    for _, client in ipairs(active_clients) do
      count = count +
                lsp.diagnostic.get_count(api.nvim_get_current_buf(), diag_type,
                                         client.id)
    end
    if count == 0 then return '' end
    return string.format('  %s %s', icon, count)
  end
end

local function separate(opts)
  name = vim.F.if_nil(opts.name, opts.key)
  hl = opts.hl or {}
  return {
    [name] = {
      provider = function()
        return (opts.condition and opts.condition() or nil) and
                 separators[opts.key]
      end,
      highlight = hl
    }
  }
end

local function line_column()
  local line, column = unpack(api.nvim_win_get_cursor(0))
  return string.format('%2d:%2d', line, column + 1)
end

local function is_lsp_attached()
  return not vim.tbl_isempty(vim.lsp.buf_get_clients())
end

local function checkwidth(width) return vim.fn.winwidth(0) / 2 > width end

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

local function get_python_env()
  local conda = os.getenv('CONDA_PROMPT_MODIFIER')
  local python = os.capture('python -V')
  if conda ~= nil then return python .. ' ' .. vim.trim(conda) end
  return python
end

-- treesitter
local transform_line =
  function(line) return line:gsub('%s*[%[%(%{]*%s*$', '') end

local get_line_for_node = function(node, type_patterns)
  local node_type = node:type()
  local is_valid = false
  for _, rgx in ipairs(type_patterns) do
    if node_type:find(rgx) then
      is_valid = true
      break
    end
  end
  if not is_valid then return '' end
  local line = transform_line(vim.trim(ts_utils.get_node_text(node)[1] or ''))
  -- escape % to avoid statusline to evaluate content as expression
  return line:gsub('%%', '%%%%')
end

-- get top node of context
local function treesitter_status()
  if not parsers.has_parser() then return end
  local indicator_size = 100
  local type_patterns = {'class', 'function', 'method'}

  local current_node = ts_utils.get_node_at_cursor()
  if not current_node then return '' end

  local lines = {}
  local expr = current_node

  while expr do
    local line = get_line_for_node(expr, type_patterns)
    if line ~= '' and not vim.tbl_contains(lines, line) then
      table.insert(lines, 1, line)
    end
    expr = expr:parent()
  end
  -- get top node
  local text = lines[1] or ''
  local text_len = #text
  if text_len > indicator_size then
    return '...' .. text:sub(text_len - indicator_size, text_len) .. ' '
  end
  return text .. ' '
end

table.insert(gls.left, {
  ViModeSeparatorLeft = {
    provider = function() return separators['left_rounded'] end,
    highlight = 'GalaxyViModeSep'
  }
})

previous_color = nil
table.insert(gls.left, {
  ViMode = {
    provider = function()
      -- change color only when mode has changed
      -- changing color otherwise slows down scrolling
      local mode = api.nvim_get_mode().mode
      local color = mode_color[mode]
      if color ~= previous_color and color ~= nil then
        api.nvim_command([[hi GalaxyViMode guifg=]] .. colors.light0_hard ..
                           [[ gui='bold' guibg=]] .. color)
        api.nvim_command([[hi GalaxyViModeSep guibg=NONE gui='bold' guifg=]] ..
                           color)
        previous_color = color
      end
      return alias[mode]
    end,
    -- circumvent clearing out highlight on save
    highlight = 'GalaxyViMode'
  }
})

table.insert(gls.left, {
  ViModeSeparatorRight = {
    provider = function() return separators['right_rounded'] end,
    highlight = 'GalaxyViModeSep'
  }
})

table.insert(gls.left,
             separate({key = 'space', condition = function() return true end}))

table.insert(gls.left, {
  FileInfoIcon = {
    provider = function() return fileinfo.get_file_icon() end,
    condition = buffer_not_empty,
    highlight = {
      require('galaxyline.provider_fileinfo').get_file_icon_color, 'NONE'
    }
  }
})

table.insert(gls.left, {
  filename = {
    provider = {'FileName', 'FileSize'},
    condition = buffer_not_empty,
    highlight = {colors.light1, 'NONE', 'bold'}
  }
})

local lsp_bg = colors.dark2

table.insert(gls.mid, separate {
  key = 'left_rounded',
  hl = {lsp_bg, 'NONE'},
  name = 'LspSepLeft',
  condition = is_lsp_attached
})

table.insert(gls.mid, {
  LSPActive = {
    provider = function() return is_lsp_attached() and ' ' or '' end,
    highlight = {colors.bright_blue, lsp_bg}
  }
})
table.insert(gls.mid, {
  LSPError = {
    provider = function() return get_nvim_lsp_diagnostic('Error', '') end,
    condition = buffer_not_empty,
    highlight = {colors.bright_red, lsp_bg}
  }
})
table.insert(gls.mid, {
  LSPWarn = {
    provider = function() return get_nvim_lsp_diagnostic('Warning', '') end,
    condition = buffer_not_empty,
    highlight = {colors.bright_yellow, lsp_bg}
  }
}) table.insert(gls.mid, {
  LSPInfo = {
    provider = function()
      return get_nvim_lsp_diagnostic('Information', '')
    end,
    condition = buffer_not_empty,
    highlight = {colors.neutral_aqua, lsp_bg}
  }
})

table.insert(gls.mid, separate {
  key = 'right_rounded',
  hl = {lsp_bg, 'NONE'},
  name = 'LspSepRight',
  condition = is_lsp_attached
})

-- table.insert(gls.right, {
--   TreeSitter = {
--     provider = function() return checkwidth(60) and treesitter_status() or '' end,
--     separator = '',
--     condition = buffer_not_empty and loaded('nvim-treesitter'),
--     separator_highlight = {colors.dark0, colors.dark0},
--     highlight = {colors.bright_yellow, 'NONE', 'bold'}
--   }
-- })

local git_bg = colors.dark1
table.insert(gls.right, separate {
  key = 'left_rounded',
  hl = {colors.dark1, 'NONE'},
  name = 'GitSepLeft',
  condition = git_condition
})

table.insert(gls.right, {
  GitIcon = {
    provider = function() return '  ' end,
    condition = git_condition,
    highlight = {colors.bright_orange, git_bg, 'bold'}
  }
})

table.insert(gls.right, {
  GitBranch = {
    provider = function()
      local status = vim.b['gitsigns_status_dict']
      if status == nil then return '' end
      local head = status.head
      for _, p in ipairs({'added', 'removed', 'changed'}) do
        if status[p] ~= nil and status[p] > 0 then
          -- head = string.format('%s ', head)
          break
        end
      end
      return head
    end,
    condition = function() return git_condition end,
    highlight = {colors.bright_orange, git_bg, 'bold'}
  }
})

table.insert(gls.right, {
  DiffAdd = {
    provider = function()
      return checkwidth(40) and gitsigns('added', '   %s')
    end,
    condition = git_condition,
    highlight = {colors.bright_green, git_bg}
  }
})

table.insert(gls.right, {
  DiffModified = {
    provider = function()
      return checkwidth(40) and gitsigns('changed', '   %s')
    end,
    condition = git_condition,
    highlight = {colors.bright_blue, git_bg}
  }
})

table.insert(gls.right, {
  DiffRemove = {
    provider = function()
      return checkwidth(40) and gitsigns('removed', '   %s')
    end,
    condition = git_condition,
    highlight = {colors.bright_red, git_bg}
  }
})

table.insert(gls.right, separate {
  key = 'right_rounded',
  hl = {git_bg, 'NONE'},
  name = 'GitSepRight',
  condition = git_condition
})
table.insert(gls.right,
             separate({key = 'space', condition = function() return true end}))

table.insert(gls.right, {
  FileEncode = {
    provider = function() return fileinfo.get_file_encode():lower() .. ' ' end,
    highlight = {colors.light4, 'NONE', 'bold'}
  }
})

table.insert(gls.right, {
  LineInfo = {provider = line_column, highlight = {colors.light1, 'NONE'}}
})

table.insert(gls.right, {
  ScrollBar = {
    provider = 'ScrollBar',
    separator = ' ',
    separator_highlight = {colors.dark0_soft, 'NONE'},
    highlight = {colors.light1, '#32302f'}
  }
})

table.insert(gls.short_line_left, {
  FileInfoIcon = {
    provider = function() return fileinfo.get_file_icon() end,
    condition = buffer_not_empty,
    highlight = {
      require('galaxyline.provider_fileinfo').get_file_icon_color, 'NONE'
    }
  }
})

table.insert(gls.short_line_left, {
  filename = {
    provider = {'FileName', 'FileSize'},
    condition = buffer_not_empty,
    highlight = {colors.light1, 'NONE', 'bold'}
  }
})
gl.load_galaxyline()
