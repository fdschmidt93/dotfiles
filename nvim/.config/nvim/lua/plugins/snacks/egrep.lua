local prefixes = {
  ["#"] = { -- filter for file suffixes
    flag = "glob",
    cb = function(input) return string.format([[*.{%s}]], input) end,
  },
  [">"] = { -- filter for (partial) folder names
    flag = "glob",
    cb = function(input) return string.format([[**/{%s}*/**]], input) end,
  },
  ["&"] = { -- filter for (partial) file names
    flag = "glob",
    cb = function(input) return string.format([[*{%s}*]], input) end,
  },
}

local prefix_handler = function(prompt_tokens, prefix, prefix_opts)
  local prefix_width = #prefix
  local indices = {}
  local args = {}
  for i, token in ipairs(prompt_tokens) do
    local token_prefix = token:sub(1, prefix_width)
    if token_prefix == prefix then
      local token_str = token:sub(prefix_width + 1, -1)
      token_str = prefix_opts.cb and prefix_opts.cb(token_str) or token_str
      if not token_str or token_str == "" then
        args[#args + 1] = string.format([[--%s]], prefix_opts.flag)
      else
        args[#args + 1] = string.format([[--%s=%s]], prefix_opts.flag, token_str)
      end
      indices[#indices + 1] = i
    end
  end
  for i = #indices, 1, -1 do
    table.remove(prompt_tokens, indices[i])
  end
  return prompt_tokens, args
end

local tokenize = function(prompt)
  local tokens = {}
  for token in prompt:gmatch "%S+" do
    tokens[#tokens + 1] = token
  end
  return tokens
end

local uv = vim.uv or vim.loop
---@class snacks.picker
---@field grep fun(opts?: snacks.picker.grep.Config): snacks.Picker
---@field grep_word fun(opts?: snacks.picker.grep.Config): snacks.Picker
---@field grep_buffers fun(opts?: snacks.picker.grep.Config): snacks.Picker

---@param opts snacks.picker.grep.Config
---@param filter snacks.picker.Filter
local function get_cmd(opts, filter)
  local cmd = "rg"
  local args = {
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "--max-columns=500",
    "--max-columns-preview",
    "-g",
    "!.git",
  }

  args = vim.deepcopy(args)

  -- hidden
  if opts.hidden then
    table.insert(args, "--hidden")
  else
    table.insert(args, "--no-hidden")
  end

  -- ignored
  if opts.ignored then
    args[#args + 1] = "--no-ignore"
  end

  -- follow
  if opts.follow then
    args[#args + 1] = "-L"
  end

  local types = type(opts.ft) == "table" and opts.ft or { opts.ft }
  ---@cast types string[]
  for _, t in ipairs(types) do
    args[#args + 1] = "-t"
    args[#args + 1] = t
  end

  if opts.regex == false then
    args[#args + 1] = "--fixed-strings"
  end

  local glob = type(opts.glob) == "table" and opts.glob or { opts.glob }
  ---@cast glob string[]
  for _, g in ipairs(glob) do
    args[#args + 1] = "-g"
    args[#args + 1] = g
  end

  local permutations = false
  local AND = true
  local prompt = filter.search or ""
  local prompt_args = {}
  local tokens = tokenize(prompt)
  if AND then
    for prefix, prefix_opts in pairs(prefixes) do
      local prefix_args
      tokens, prefix_args = prefix_handler(tokens, prefix, prefix_opts)
      prompt_args[#prompt_args + 1] = prefix_args
    end
  end
  if not permutations then
    prompt = table.concat(tokens, " ")
    -- matches everything in between sub-tokens of prompt
    if AND then
      prompt = prompt:gsub("%s", ".*")
    end
  else -- matches everything in between sub-tokens and permutations
    -- prompt = egrep_utils.permutations(tokens)
  end

  for _, arg in ipairs(prompt_args) do
    if type(arg) == "string" then
      args[#args + 1] = arg
    elseif type(arg) == "table" then
      for _, subarg in ipairs(arg) do
        args[#args + 1] = subarg
      end
    end
  end
  args[#args + 1] = "--"
  args[#args + 1] = prompt

  -- search pattern

  local paths = {} ---@type string[]

  if opts.buffers then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" and vim.bo[buf].buflisted and uv.fs_stat(name) then
        paths[#paths + 1] = name
      end
    end
  elseif opts.dirs and #opts.dirs > 0 then
    paths = opts.dirs or {}
  end

  -- dirs
  if #paths > 0 then
    paths = vim.tbl_map(vim.fs.normalize, paths) ---@type string[]
    vim.list_extend(args, paths)
  end
  return cmd, args
end

local function egrep(opts, ctx)
  if opts.need_search ~= false and ctx.filter.search == "" then
    return function() end
  end
  local absolute = (opts.dirs and #opts.dirs > 0) or opts.buffers or opts.rtp
  local cwd = not absolute and vim.fs.normalize(opts and opts.cwd or uv.cwd() or ".") or nil
  local cmd, args = get_cmd(opts, ctx.filter)
  return require("snacks.picker.source.proc").proc(ctx:opts({
    cmd = cmd,
    args = args,
    notify = false, -- never notify on grep errors, since it's impossible to know if the error is due to the search pattern
    ---@param item snacks.picker.finder.Item
    transform = function(item)
      item.cwd = cwd
      local file, line, col, text = item.text:match "^(.+):(%d+):(%d+):(.*)$"
      if not file then
        if not item.text:match "WARNING" then
          error("invalid grep output: " .. item.text)
        end
        return false
      else
        item.line = text
        item.file = file
        item.pos = { tonumber(line), tonumber(col) - 1 }
      end
    end,
  }), ctx)
end

return egrep
