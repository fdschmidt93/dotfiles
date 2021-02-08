local gl = require('galaxyline')
local vcs = require('galaxyline.provider_vcs')
local gls = gl.section
local extension = require('galaxyline.provider_extensions')
local colors = require('colors.gruvbox')

local function TrailingWhiteSpace()
     local trail = vim.fn.search("\\s$", "nw")
     if trail ~= 0 then
         return trail
     else
         return nil
     end
 end

-- show line:column
function line_column()
  local line = vim.fn.line('.')
  local column = vim.fn.col('.')
  -- fix formatting
  if column < 10 then
        column = ' ' .. column
  end
  if line < 10 then
        line = ' ' .. line
  end
  return line .. ':' .. column
end


function has_file_type()
     local f_type = vim.bo.filetype
     if not f_type or f_type == '' then
         return false
     end
     return true
 end

function is_filetype(filetype)
    if vim.bo.filetype == filetype then
        return true
    end
    return false
end

local function checkwidth()
    -- local squeeze_width  = vim.fn.winwidth(0) / 2
    -- half a window
    if vim.fn.winwidth(0) / 2 > 60 then
       return true
    end
    return false
end

local function is_term()
    return vim.bo.buftype == 'terminal' end


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

local function CondaEnv()
   if checkwidth() then
       conda = os.getenv('CONDA_PROMPT_MODIFIER')
       python = os.capture('python -V')
       if conda ~= nil then
           return python .. ' ' .. conda
       end
       return python .. ' '
    end
    return ''
end

local buffer_not_empty = function()
   if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
     return true
   end
   return false
end

local TreeSitter = function()
    if checkwidth() then
        ts_class = require('nvim-treesitter').statusline{indicator_size=100, type_patterns={'class'}}
        ts_fun = require('nvim-treesitter').statusline{indicator_size=100, type_patterns={'function'}}
        if ts_class == nil or ts_class == '' then
            ts_status = ts_fun
        else
            ts_status = ts_class
        end
        if ts_status ~= nil and ts_status ~= '' then
           ts_status = string.sub(ts_status, 1, 40)
       return ts_status
        end
        return ''
    end
    return ''
end

-- gls.left[1] = {
--   FirstElement = {
--     provider = function() return ' ' end,
--     highlight = {colors.dark0_soft,colors.dark0_soft}
--   },
-- }

gls.left[2] = {
  ViMode = {
    provider = function()
      -- auto change color according the vim mode
      local alias = {
          n = 'NORMAL',
          i = 'INSERT',
          c= 'COMMAND',
          V= 'VISUAL',
          [''] = 'VISUAL',
          v ='VISUAL',
          ['r?'] = ':CONFIRM',
          rm = '--MORE',
          R  = 'REPLACE',
          Rv = 'VIRTUAL',
          s  = 'SELECT',
          S  = 'SELECT',
          ['r']  = 'HIT-ENTER',
          [''] = 'SELECT',
          t  = 'TERMINAL',
          ['!']  = 'SHELL',
      }
      local mode_color = {
          n = colors.bright_green,
          t = colors.neutral_green,
          ['!']  = colors.faded_green,
          c  = colors.faded_green,
          i = colors.bright_blue,
          v=colors.bright_purple,
          [''] = colors.neutral_purple,
          V=colors.faded_purple,
          c = colors.faded_green,
          no = colors.magenta,
          s = colors.orange,S=colors.orange,
          [''] = colors.orange,
          ic = colors.neutral_yellow,
          R = colors.purple,
          Rv = colors.purple,
          cv = colors.red,ce=colors.red,
          r = colors.neutral_aqua,
          rm = colors.bright_aqua, 
          ['r?'] = colors.faded_aqua,
          ['r']  = colors.neutral_yellow,
          rm = colors.bright_yellow,
          R  = colors.faded_yellow,
          Rv = colors.faded_yellow,
      }
    
      local vim_mode = vim.fn.mode()
      if vim.tbl_contains(mode_color, vim_mode) then
          vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim_mode])
          return '  ' .. alias[vim_mode] .. '  '
      else
          return ''
      end
    end,
    highlight = {colors.light0_hard,colors.dark0_soft, 'bold'},
  },
}

gls.left[3] ={
  SpaceA = {
    provider = function() return '█' end,
    condition = buffer_not_empty,
    highlight = {colors.dark1, colors.dark0_soft},
  },
}

gls.left[4] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = buffer_not_empty,
    highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.dark1},
  },
}

gls.left[5] = {
  FileName = {
    provider = {'FileName', 'FileSize'},
    condition = buffer_not_empty,
    highlight = {colors.light1, colors.dark1, 'bold'},
    separator = '',
    separator_highlight = {colors.dark0, colors.dark1}
  },
}

gls.left[7] = {
  SpaceC = {
    provider = function () return ' ' end,
      highlight = {colors.dark0, colors.dark0},
  }
}

gls.left[8] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    condition = buffer_not_empty,
    highlight = {colors.bright_red,colors.dark0}
  }
}
gls.left[9] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.neutral_yellow,colors.dark0},
  }
}
gls.left[10] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    condition = buffer_not_empty,
    highlight = {colors.light1,colors.dark0}
  }
}
gls.left[11] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.neutral_aqua,colors.dark0},
  }
}


gls.right[0] = {
  TreeSitter = {
  provider = TreeSitter,
  -- provider = function() return vim.b.lsp_current_function end,
  separator = '',
  condition = buffer_not_empty,
  separator_highlight = {colors.dark0,colors.dark0},
  highlight = {colors.bright_yellow,colors.dark0, 'bold'},
  }
}

gls.right[1] = {
  CondaEnv = {
  provider = CondaEnv,
  separator = ' ',
  separator_highlight = {colors.dark0, colors.dark0},
  condition = function () return is_filetype('python') end,
  highlight = {colors.bright_green, colors.dark0, 'bold'},
  }
}

gls.right[2]= {
  FileEncode = {
    provider = 'FileEncode',
    separator = '',
    separator_highlight = {colors.dark0,colors.dark0_soft},
    highlight = {colors.light1,colors.dark0_soft, 'bold'},
  }
}

-- gls.right[3] = {
--   LineSeparator = {
--     provider = function() return '  | ' end,
--     condition = function() return require('galaxyline.provider_vcs').check_git_workspace() and buffer_not_empty() and has_file_type() end,
--     highlight = {colors.bright_blue,colors.dark0_soft},
--   },
-- }

-- gls.right[4] = {
--   GitIcon = {
--     provider = function() return '  ' end,
--     condition = function() return require('galaxyline.provider_vcs').check_git_workspace() and buffer_not_empty() and has_file_type() end,
--     -- condition = require('galaxyline.provider_vcs').check_git_workspace,
--     highlight = {colors.bright_orange,colors.dark0_soft},
--   }
-- }

-- -- in some files branch cuts off last space
-- local function get_git_branch()
--     branch = vcs.get_git_branch()
--     if branch == nil then
--         return ''
--     end
--     if branch:sub(-1) == ' ' then
--         return string.sub(branch, 1, -2)
--     end
--     return branch
-- end


-- gls.right[5] = {
--   GitBranch = {
--     provider = 'GitBranch',
--     condition = function() return require('galaxyline.provider_vcs').check_git_workspace and buffer_not_empty() and has_file_type() end,
--     highlight = {'#8FBCBB',colors.dark0_soft,'bold'},
--   }
-- }


gls.right[5] = {
  LineInfo = {
    -- provider = 'LineColumn',
    provider = line_column,
    separator = ' | ',
    separator_highlight = {colors.bright_blue,colors.dark0_soft},
    highlight = {colors.light1,colors.dark0_soft},
  },
}
gls.right[6] = {
  ScrollBar = {
    provider = 'ScrollBar',
    separator = '  ',
    separator = ' ',
    separator_highlight = {colors.dark0_soft,colors.dark0_soft},
    highlight = {colors.light1,colors.dark0},
  }
}

-- gls.short_line_left[1] = {
--   FileTypeName = {
--     provider = 'FileTypeName',
--     condition = has_file_type,
--     separator = '',
--     separator_highlight = {colors.dark1,colors.dark0},
--     highlight = {colors.light1, colors.dark1}
--   }
-- }

-- gls.short_line_left[1] ={
--   FileIcon = {
--     provider = 'FileIcon',
--     condition = buffer_not_empty,
--     highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.dark0_soft},
--   },
-- }
-- gls.short_line_left[2] = {
--   FileName = {
--     provider = 'FileName',
--     condition = buffer_not_empty,
--     highlight = {colors.light1,colors.dark0_soft,'bold'},
--     separator = '',
--     separator_highlight = {colors.dark0,colors.dark0_soft},
--   }
-- }

return gl
