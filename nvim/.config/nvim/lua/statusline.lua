-- only load settings if module is available to avoid packer issues
-- if not loaded('galaxyline.nvim') then return end
local gl = require 'galaxyline'
local vcs = require('galaxyline.provider_vcs')
local condition = require('galaxyline.condition')
local fileinfo = require('galaxyline.provider_fileinfo')
local gls = gl.section
local colors = require('colors.gruvbox')
local ts_utils = require('nvim-treesitter.ts_utils')
local parsers = require 'nvim-treesitter.parsers'

local color = {}

gl.separate = false
if gl.separate == false then
  for k, v in pairs(colors) do
    if k:match('dark') then
      color[k] = '#3c3836'
    else
      color[k] = v
    end
  end
else
  color = colors
end

local function line_column()
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  return string.format('%2d:%2d', line, column + 1)
end

local function has_file_type()
  local f_type = vim.bo.filetype
  if not f_type or f_type == '' then return false end
  return true
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

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then return true end
  return false
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

local separators = {left = '', right = ''}

gls.left[1] = {
  vimode = {
    provider = function()
      -- auto change color according the vim mode
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
        r = color.faded_yellow,
        rv = color.faded_yellow,
        v = color.faded_purple,
        [''] = color.orange,
        [''] = color.neutral_purple,
        ['!'] = color.faded_green,
        ['r'] = color.neutral_aqua,
        ['r?'] = color.faded_aqua,
        c = color.faded_green,
        cv = color.red,
        ce = color.red,
        i = color.bright_blue,
        ic = color.neutral_yellow,
        n = color.bright_green,
        no = color.magenta,
        rm = color.bright_aqua,
        s = color.orange,
        s = color.orange,
        t = color.neutral_green,
        V = color.bright_purple
      }
      local vim_mode = vim.api.nvim_get_mode().mode
      if mode_color[vim_mode] ~= nil then
        vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim_mode])
        return ' ▌' .. alias[vim_mode] -- ..  '  '
      else
        return ''
      end
    end,
    highlight = {color.light0_hard, color.dark0, 'bold'},
    separator = separators['right'],
    separator_highlight = {
      color.dark0,
      function()
        return buffer_not_empty() and color.dark0_soft or color.dark0
      end
    }
  }
}

gls.left[3] = {
  FileInfoIcon = {
    provider = function() return ' ' .. fileinfo.get_file_icon() end,
    condition = buffer_not_empty,
    highlight = {
      require('galaxyline.provider_fileinfo').get_file_icon_color,
      color.dark0_soft
    }
  }
}

gls.left[4] = {
  filename = {
    provider = {'FileName', 'FileSize'},
    condition = buffer_not_empty,
    highlight = {color.light1, color.dark0_soft, 'bold'},
    separator = separators['right'],
    separator_highlight = {
      color.dark0_soft,
      condition.check_git_workspace() and color.dark1 or color.dark0
    }
  }
}

gls.left[5] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = function()
      return condition.check_git_workspace() and buffer_not_empty() and
               has_file_type()
    end,
    highlight = {color.bright_orange, color.dark1, 'bold'}
  }
}

gls.left[6] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = function()
      return condition.check_git_workspace() and buffer_not_empty() and
               has_file_type()
    end,
    highlight = {color.bright_orange, color.dark1, 'bold'}
  }
}

gls.left[7] = {
  DiffAdd = {
    provider = function() return checkwidth(40) and vcs.diff_add() or '' end,
    -- separator = ' ',
    -- separator_highlight = {color.purple,color.bg},
    condition = function()
      return condition.check_git_workspace() and buffer_not_empty() and
               has_file_type()
    end,
    icon = checkwidth(40) and '  ' or '',
    highlight = {color.bright_green, color.dark1}
  }
}
gls.left[8] = {
  DiffModified = {
    provider = function() return checkwidth(40) and vcs.diff_modified() or '' end,
    -- separator = ' ',
    -- separator_highlight = {color.purple,color.bg},
    condition = function()
      return condition.check_git_workspace() and buffer_not_empty() and
               has_file_type()
    end,
    icon = checkwidth(40) and '  ' or '',
    highlight = {color.bright_blue, color.dark1}
  }
}
gls.left[9] = {
  DiffRemove = {
    provider = function() return checkwidth(40) and vcs.diff_remove() or '' end,
    separator = separators['right'],
    separator_highlight = {color.dark1, color.dark0},
    condition = function()
      return condition.check_git_workspace() and buffer_not_empty() and
               has_file_type()
    end,
    icon = checkwidth(40) and '  ' or '',
    highlight = {color.bright_red, color.dark1}
  }
}

gls.left[10] = {
  Space = {
    provider = function() return ' ' end,
    highlight = {color.dark0, color.dark0}
  }
}

gls.left[11] = {
  LSPActive = {
    provider = function()
      return not vim.tbl_isempty(vim.lsp.buf_get_clients()) and '  ' or ''
    end,
    highlight = {color.bright_blue, color.dark0}
  }
}

gls.left[12] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    condition = buffer_not_empty,
    highlight = {color.bright_red, color.dark0}
  }
}
gls.left[13] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    condition = buffer_not_empty,
    highlight = {color.neutral_yellow, color.dark0}
  }
}
gls.left[14] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    condition = buffer_not_empty,
    highlight = {color.neutral_aqua, color.dark0}
  }
}

gls.right[0] = {
  TreeSitter = {
    provider = function() return checkwidth(60) and treesitter_status() or '' end,
    separator = '',
    condition = buffer_not_empty and loaded('nvim-treesitter'),
    separator_highlight = {color.dark0, color.dark0},
    highlight = {color.bright_yellow, color.dark0, 'bold'}
  }
}

gls.right[1] = {
  CondaEnv = {
    provider = function() return checkwidth(60) and get_python_env() or '' end,
    separator = ' ',
    separator_highlight = {color.dark0, color.dark0},
    condition = function() return vim.bo.filetype == 'python' end,
    highlight = {color.bright_green, color.dark0, 'bold'}
  }
}

gls.right[2] = {
  FileEncode = {
    provider = function() return fileinfo.get_file_encode():lower() .. '  ' end,
    highlight = {color.light4, color.dark0_soft, 'bold'},
    separator = separators['left'],
    separator_highlight = {color.dark0_soft, color.dark0}
  }
}

gls.right[3] = {
  LineInfo = {
    provider = line_column,
    -- separator = ' | ',
    -- separator_highlight = {color.light4, color.dark0_soft},
    highlight = {color.light1, color.dark0_soft}
  }
}

gls.right[4] = {
  ScrollBar = {
    provider = 'ScrollBar',
    separator = ' ',
    separator_highlight = {color.dark0_soft, color.dark0_soft},
    highlight = {color.light1, '#32302f'}
  }
}

gl.load_galaxyline()
