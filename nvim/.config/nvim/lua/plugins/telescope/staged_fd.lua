local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local utils = require "telescope.utils"
local conf = require("telescope.config").values
local sorters = require "telescope.sorters"

--- Tokenizes the `prompt` into space-separated tokens (i.e. words)
--- @param prompt string: the prompt to tokenize
--- @return table: the tokens in the prompt
local function tokenize(prompt)
  local tokens = {}
  for token in prompt:gmatch "%S+" do
    tokens[#tokens + 1] = token
  end
  return tokens
end

-- Sorter function for telescope
-- Prefers shorter matches for staged fd.
local sort_fn = sorters.Sorter:new {
  discard = true,
  scoring_function = function(_, prompt, _)
    local score = prompt:len()
    if score == 0 then
      return -1
    else
      return 1 / score
    end
  end,
}

--- Return regex to match all permutations of tokens with wildcards inbetween
--- Example: this test -> (this.*test|test.*this)
--- Note: this is **almost** order invariant
--- @param tokens string[]: the prompt tokens
--- @return string: the regex pattern
local function permutations(tokens)
  local result = {}
  local function permute(tokens_, i, n)
    if i == n then
      table.insert(result, table.concat(tokens_, ".*"))
    else
      for j = i, n do
        tokens_[i], tokens_[j] = tokens_[j], tokens_[i]
        permute(tokens_, i + 1, n)
        tokens_[i], tokens_[j] = tokens_[j], tokens_[i]
      end
    end
  end
  permute(tokens, 1, #tokens)
  return string.format("%s%s%s", "(", table.concat(result, "|"), ")")
end

-- Lookup keys for file entries
local lookup_keys = {
  ordinal = 1,
  value = 1,
  filename = 1,
}

--- Generate a entry from a json stream of `rg`.
--- @param opts table: options for the file entry
--- @return function: a function that takes a stream and returns a file entry
local function gen_from_file(opts)
  opts = opts or {}

  local cwd = vim.fn.expand(vim.F.if_nil(opts.cwd, vim.loop.cwd()))

  local disable_devicons = opts.disable_devicons
  local mt_file_entry = {}
  mt_file_entry.cwd = cwd
  mt_file_entry.display = function(entry)
    local hl_group, icon
    local display = utils.transform_path(opts, entry[1])
    display, hl_group, icon = utils.transform_devicons(entry[1], display, disable_devicons)
    if hl_group then
      local begin = #icon
      local highlights = { { { 0, begin }, hl_group } }
      begin = begin + 1 -- space between icon and filename
      for _, match in ipairs(entry["submatches"]) do
        highlights[#highlights + 1] = { { match["start"] + begin, match["end"] + begin }, "TelescopeMatching" }
      end
      return display, highlights
    else
      return display
    end
  end
  mt_file_entry.__index = function(t, k)
    local raw = rawget(mt_file_entry, k)
    if raw then
      return raw
    end
    if k == "path" then
      local retpath = vim.fs.joinpath(t.cwd, t.value)
      if vim.fn.filereadable(retpath) == 0 then
        retpath = t.value
      end
      return retpath
    end
    return rawget(t, rawget(lookup_keys, k))
  end

  return function(stream)
    local ok, json_line = pcall(vim.json.decode, stream)
    if not ok then
      return
    end
    if json_line["type"] ~= "match" then
      return
    end
    local line = json_line["data"]["lines"]["text"]:sub(1, -2) -- trim \n
    local entry = {
      [1] = line,
    }
    entry.submatches = json_line["data"]["submatches"]
    return setmetatable(entry, mt_file_entry)
  end
end

--- Find files with `staged fd` using telescope that never blocks
--- Staged fd:
---     1. Run `fd`, output to file
---     2. Run `rg` with customizations on file
--- Customized `rg`:
---     - Match permutations for order-invariant AND operator, e.g. this test -> (this.*test|test.*this)
---     - Custom sorter to prefer shorter file names (i.e., light-loaded resorting `rg` output with telescope in lua)
---     - Use `rg` json to highlight matches
--- @param opts table: options for finding files
--- @return function: the find_files function
return function(opts)
  opts = opts or {}

  local cache = vim.fs.joinpath(vim.fn.stdpath "cache", "telescope-staged-fd")
  if vim.fn.isdirectory(cache) == 0 then
    vim.fn.mkdir(cache)
    for p in vim.fs.dir(cache) do
      -- remove dead entries
      if vim.fn.filereadable(p) == 1 then
        vim.fn.delete(p)
      end
    end
  end
  local cwd = vim.uv.cwd()
  local filename = os.time() -- store each search by lua timestamp
  local path = vim.fs.joinpath(cache, filename)

  -- launch `fd` and output result to $NVIM_CACHE/telescope-fd/$TIMESTAMP
  vim.fn.jobstart(string.format("fd -t=f --base-directory=%s > %s", cwd, path))

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopePrompt",
    once = true,
    callback = function(args)
      vim.api.nvim_create_autocmd({ "BufLeave", "BufDelete" }, {
        buffer = args.buf,
        once = true,
        callback = function()
          if vim.fn.filereadable(path) == 1 then
            local ret = vim.fn.delete(path)
            if ret ~= 0 then
              vim.notify "Deletion failed!"
            end
          end
        end,
      })
    end,
  })

  local find_command = finders.new_job(function(prompt)
    if not prompt or prompt == "" then
      return nil
    end
    local tokens = tokenize(prompt)
    local file_ext_ids = {}
    local file_ext = {}

    -- If tokens in prompt end in `$`
    --   1. Group them (i.e., py$ lua$ -> *.(py|lua)$)
    --   2. Move them to end of prompt such that they are not included in permutations
    for i, t in ipairs(tokens) do
      if t:sub(-1, -1) == "$" then
        table.insert(file_ext_ids, i)
        file_ext[#file_ext + 1] = vim.split(t:sub(1, -2), ",")
      end
    end

    for i = #file_ext_ids, 1, -1 do
      table.remove(tokens, file_ext_ids[i])
    end
    prompt = permutations(tokens)
    if not vim.tbl_isempty(file_ext) then
      file_ext = vim.tbl_filter(function(x)
        return x ~= ""
      end, vim.tbl_flatten(file_ext))
      prompt = prompt .. string.format([[.*(%s)$]], table.concat(file_ext, "|"))
    end
    return { "rg", "-N", "--color=never", "--smart-case", "--json", "--", prompt, path }
  end, gen_from_file(opts), opts.max_results, cwd)

  _ = pickers
      .new(opts, {
        prompt_title = "Find Files",
        finder = find_command,
        previewer = conf.file_previewer(opts),
        sorter = sort_fn,
      })
      :find()
end
