-- only load settings if module is available to avoid packer issues
local status, gl = pcall(require, "galaxyline")
if not status then
  return
end

local conditions = require "plugins.statusline.conditions"
local utils = require "plugins.statusline.utils"

local fileinfo = require "galaxyline.provider_fileinfo"
local gls = gl.section
local colors = require "highlights.gruvbox"
-- local ts_utils = require('nvim-treesitter.ts_utils')
-- local parsers = require 'nvim-treesitter.parsers'
local api = vim.api
-- ensure inactive only shows short_line_{left, right}
gl.short_line_list = { " ", "NvimTree", "packer" }

local alias = {
  r = "replace",
  rv = "virtual",
  [""] = "select",
  [""] = "visual",
  ["!"] = "shell",
  ["r"] = "hit-enter",
  ["r?"] = ":confirm",
  c = "command",
  i = "insert",
  ic = "insert",
  n = "normal",
  rm = "--more",
  s = "select",
  t = "terminal",
  v = "visual",
  V = "visual",
}
local mode_color = {
  r = colors.faded_yellow,
  rv = colors.faded_yellow,
  v = colors.faded_purple,
  [""] = colors.orange,
  [""] = colors.neutral_purple,
  ["!"] = colors.faded_green,
  ["r"] = colors.neutral_aqua,
  ["r?"] = colors.faded_aqua,
  c = colors.faded_green,
  cv = colors.red,
  ce = colors.red,
  i = colors.bright_blue,
  ic = colors.neutral_yellow,
  n = colors.bright_green,
  no = colors.magenta,
  rm = colors.bright_aqua,
  s = colors.orange,
  t = colors.neutral_green,
  V = colors.bright_purple,
}
-- only load on enter
local PythonEnv = utils.get_python_env()

table.insert(gls.left, {
  ViModeSeparatorLeft = {
    provider = function()
      return utils.separators["left_rounded"]
    end,
    highlight = "GalaxyViModeSep",
  },
})

local previous_color = nil
table.insert(gls.left, {
  ViMode = {
    provider = function()
      -- change color only when mode has changed
      -- changing color otherwise slows down scrolling
      local mode = api.nvim_get_mode().mode
      local color = mode_color[mode]
      if color ~= previous_color and color ~= nil then
        api.nvim_command(
          [[hi GalaxyViMode guifg=]] .. colors.light0_hard .. [[ gui='bold' guibg=]] .. color
        )
        api.nvim_command([[hi GalaxyViModeSep guibg=NONE gui='bold' guifg=]] .. color)
        previous_color = color
      end
      return alias[mode]
    end,
    -- circumvent clearing out highlight on save
    highlight = "GalaxyViMode",
  },
})

table.insert(gls.left, {
  ViModeSeparatorRight = {
    provider = function()
      return utils.separators["right_rounded"]
    end,
    highlight = "GalaxyViModeSep",
  },
})

table.insert(
  gls.left,
  utils.separate {
    name = "SpaceViMode",
    key = "space",
    condition = function()
      return true
    end,
  }
)

table.insert(gls.left, {
  FileInfoIcon = {
    provider = function()
      return fileinfo.get_file_icon()
    end,
    condition = conditions.buffer_not_empty,
    highlight = { require("galaxyline.provider_fileinfo").get_file_icon_color, "NONE" },
  },
})

table.insert(gls.left, {
  filename = {
    provider = { "FileName", "FileSize" },
    condition = conditions.buffer_not_empty,
    highlight = { colors.light1, "NONE", "bold" },
  },
})

local lsp_bg = colors.dark2

table.insert(
  gls.mid,
  utils.separate {
    key = "left_rounded",
    hl = { lsp_bg, "NONE" },
    name = "LspSepLeft",
    condition = conditions.is_lsp_attached,
  }
)

table.insert(gls.mid, {
  LSPActive = {
    provider = function()
      return conditions.is_lsp_attached() and " " or ""
    end,
    highlight = { colors.bright_blue, lsp_bg },
  },
})
table.insert(gls.mid, {
  LSPError = {
    provider = function()
      return utils.get_nvim_lsp_diagnostic("Error", "")
    end,
    condition = conditions.buffer_not_empty,
    highlight = { colors.bright_red, lsp_bg },
  },
})
table.insert(gls.mid, {
  LSPWarn = {
    provider = function()
      return utils.get_nvim_lsp_diagnostic("Warning", "")
    end,
    condition = conditions.buffer_not_empty,
    highlight = { colors.bright_yellow, lsp_bg },
  },
})
table.insert(gls.mid, {
  LSPInfo = {
    provider = function()
      return utils.get_nvim_lsp_diagnostic("Information", "")
    end,
    condition = conditions.buffer_not_empty,
    highlight = { colors.neutral_aqua, lsp_bg },
  },
})

table.insert(
  gls.mid,
  utils.separate {
    key = "right_rounded",
    hl = { lsp_bg, "NONE" },
    name = "LspSepRight",
    condition = conditions.is_lsp_attached,
  }
)

local git_bg = colors.dark1
table.insert(
  gls.right,
  utils.separate {
    key = "left_rounded",
    hl = { colors.dark1, "NONE" },
    name = "GitSepLeft",
    condition = conditions.git_condition,
  }
)

table.insert(gls.right, {
  GitIcon = {
    provider = function()
      return "  "
    end,
    condition = conditions.git_condition,
    highlight = { colors.bright_orange, git_bg, "bold" },
  },
})

table.insert(gls.right, {
  GitBranch = {
    provider = function()
      local status = vim.b["gitsigns_status_dict"]
      if status == nil then
        return ""
      end
      local head = status.head
      for _, p in ipairs { "added", "removed", "changed" } do
        if status[p] ~= nil and status[p] > 0 then
          -- head = string.format('%s ', head)
          break
        end
      end
      return head
    end,
    condition = conditions.git_condition,
    highlight = { colors.bright_orange, git_bg, "bold" },
  },
})

table.insert(gls.right, {
  DiffAdd = {
    provider = function()
      return utils.checkwidth(40) and utils.gitsigns("added", "   %s")
    end,
    condition = conditions.git_condition,
    highlight = { colors.bright_green, git_bg },
  },
})

table.insert(gls.right, {
  DiffModified = {
    provider = function()
      return utils.checkwidth(40) and utils.gitsigns("changed", "   %s")
    end,
    condition = conditions.git_condition,
    highlight = { colors.bright_blue, git_bg },
  },
})

table.insert(gls.right, {
  DiffRemove = {
    provider = function()
      return utils.checkwidth(40) and utils.gitsigns("removed", "   %s")
    end,
    condition = conditions.git_condition,
    highlight = { colors.bright_red, git_bg },
  },
})

table.insert(
  gls.right,
  utils.separate {
    key = "right_rounded",
    hl = { git_bg, "NONE" },
    name = "GitSepRight",
    condition = conditions.git_condition,
  }
)
table.insert(
  gls.right,
  utils.separate {
    name = "SpaceGit",
    key = "space",
    condition = function()
      return true
    end,
  }
)

table.insert(gls.right, {
  CondaEnv = {
    provider = function()
      return PythonEnv
    end,
    highlight = { colors.bright_green, "NONE", "bold" },
    condition = function()
      return vim.bo.filetype == "python"
    end,
  },
})
table.insert(
  gls.right,
  utils.separate {
    name = "PythonSpace",
    key = "space",
    condition = function()
      return vim.bo.filetype == "python"
    end,
  }
)

table.insert(gls.right, {
  FileEncode = {
    provider = function()
      return fileinfo.get_file_encode():lower()
    end,
    condition = conditions.buffer_not_empty,
    highlight = { colors.light4, "NONE", "bold" },
  },
})
table.insert(
  gls.right,
  utils.separate {
    name = "EncodeSpace",
    key = "space",
    condition = function()
      return true
    end,
  }
)

table.insert(
  gls.right,
  { LineInfo = { provider = utils.line_column, highlight = { colors.light1, "NONE" } } }
)

table.insert(gls.right, {
  ScrollBar = {
    provider = "ScrollBar",
    separator = " ",
    separator_highlight = { colors.dark0_soft, "NONE" },
    highlight = { colors.light1, "#32302f" },
  },
})

table.insert(gls.short_line_left, {
  FileInfoIcon = {
    provider = function()
      return fileinfo.get_file_icon()
    end,
    condition = conditions.buffer_not_empty,
    highlight = { require("galaxyline.provider_fileinfo").get_file_icon_color, "NONE" },
  },
})

table.insert(gls.short_line_left, {
  filename = {
    provider = { "FileName", "FileSize" },
    condition = conditions.buffer_not_empty,
    highlight = { colors.light1, "NONE", "bold" },
  },
})
gl.load_galaxyline()
