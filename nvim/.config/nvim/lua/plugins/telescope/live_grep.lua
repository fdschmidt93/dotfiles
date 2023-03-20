local actions = require "telescope.actions"
local finders = require "telescope.finders"
local entry_display = require "telescope.pickers.entry_display"
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"
local conf = require("telescope.config").values
local utils = require "telescope.utils"

local flatten = vim.tbl_flatten

-- stupid simple line separator
local suffix =
  " ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────"

local my_make_entry = function(stream)
  local json = vim.json.decode(stream)
  if json then
    if json["type"] == "match" then
      local data = json["data"]
      local filename = data["path"]["text"]
      local lnum = data["line_number"]
      local text = data["lines"]["text"]:gsub("\n", " ")
      data.text = text
      if text == " " then
        return nil
      end
      local start = data["submatches"][1]["start"]
      local line_displayer = entry_display.create {
        separator = " ",
        items = {
          -- { width = #tostring(lnum) },
          -- { width = #tostring(start) },
          -- { width = 8},
          { width = 4 },
          { remaining = true },
        },
      }
      local display = function()
        return line_displayer {
          {
            -- string.format("%s:%s", lnum, start),
            string.format("%s:", lnum),
            function()
              return {
                { { 0, #tostring(lnum) }, "GruvboxBlueBold" },
                -- { { #tostring(lnum), 8 }, "GruvboxAquaBold" },
              }
            end,
          },
          {
            text,
            function()
              local highlights = {}
              local beginning = 0
              for _, submatch in ipairs(data["submatches"]) do
                local s = submatch["start"]
                local f = submatch["end"]
                -- highlights[#highlights + 1] = { { beginning, s }, "GruvboxFg3" }
                highlights[#highlights + 1] = { { s, f }, "TelescopeMatching" }
                beginning = f
              end
              -- highlights[#highlights + 1] = { { beginning, #text }, "GruvboxFg3" }
              return highlights
            end,
          },
        }
      end

      local entry = {
        filename = filename,
        lnum = lnum,
        -- byte offset
        col = start + 1,
        value = data,
        ordinal = text,
        display = display,
      }
      return entry
    elseif
      -- parse the begin of rg json output
      json["type"] == "begin"
    then
      local filename = json["data"]["path"]["text"]

      local display_filename = utils.transform_path({ cwd = vim.loop.cwd() }, filename)
      -- local title_displayer = entry_display.create {
      --   separator = " ",
      --   items = {
      --     { remaining = true },
      --   },
      -- }

      local display, hl_group = utils.transform_devicons(display_filename, display_filename .. suffix, false)
      return {
        value = filename,
        ordinal = filename,
        display = function()
          if hl_group then
            return display, { { { 1, 3 }, hl_group }, { { 4, 4 + #display_filename }, "@text.strong.emphasis" } }
          else
            return display
          end
        end,
      }
    end
  end
  return nil
end

local function tokenize(prompt)
  local tokens = {}
  for token in prompt:gmatch "%S+" do
    tokens[#tokens + 1] = token
  end
  return tokens
end

local function prefix_builder(opts)
  return function(tokens)
    local indices = {}
    local args = {}
    for i, token in ipairs(tokens) do
      local token_prefix = token:sub(1, #opts.prefix)
      if token_prefix == opts.prefix then
        local token_str = token:sub(#opts.prefix + 1, -1)
        token_str = opts.cb and opts.cb(token_str) or token_str
        args[#args + 1] = string.format([[--%s=%s]], opts.flag, token_str)
        indices[#indices + 1] = i
      end
    end
    for i = #indices, 1, -1 do
      table.remove(tokens, indices[i])
    end
    return tokens, args
  end
end

return function(opts)
  opts = opts or {}
  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

  local args = flatten { vimgrep_arguments, { "--json" } }

  opts.prefixes = {
    -- filter for file suffixes
    prefix_builder {
      prefix = "#",
      flag = "glob",
      cb = function(input)
        return string.format([[*.{%s}]], input)
      end,
    },
    prefix_builder {
      -- filter for (partial) folder names
      prefix = ">",
      flag = "glob",
      cb = function(input)
        return string.format([[**/{%s}*/**]], input)
      end,
    },
    prefix_builder {
      -- filter for (partial) file names
      prefix = "&",
      flag = "glob",
      cb = function(input)
        return string.format([[*{%s}*]], input)
      end,
    },
  }

  local live_grepper = finders.new_job(function(prompt)
    if not prompt or prompt == "" then
      return nil
    end

    local tokens = tokenize(prompt)
    local prompt_args = {}
    for _, prefix_fn in ipairs(opts.prefixes) do
      local prefix_args
      tokens, prefix_args = prefix_fn(tokens)
      prompt_args[#prompt_args + 1] = prefix_args
    end
    prompt = vim.trim(table.concat(tokens, " "):gsub("%s", ".*"))
    -- vim.print(flatten { prompt_args, "--", prompt })
    return flatten { args, prompt_args, "--", prompt }
  end, my_make_entry, opts.max_results, opts.cwd)

  pickers
    .new(opts, {
      prompt_title = "Live Grep",
      finder = live_grepper,
      previewer = conf.grep_previewer(opts),
      sorter = sorters.empty(),
      attach_mappings = function(_, map)
        map("i", "<c-space>", actions.to_fuzzy_refine)
        return true
      end,
    })
    :find()
end
