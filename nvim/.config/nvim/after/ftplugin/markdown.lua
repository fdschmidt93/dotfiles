local zathura = {}
local enable_autocmd = false
local api = vim.api

local replace_extension = function(path, ext)
  local offset
  for i = #path, 1, -1 do
    if path:sub(i, i) == "." then
      offset = i
      break
    end
  end
  return path:sub(1, offset) .. ext
end

api.nvim_create_augroup("Pandoc", { clear = true })

api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  group = "Pandoc",
  callback = function()
    if enable_autocmd then
      local bufnr = api.nvim_get_current_buf()
      local abs_path = api.nvim_buf_get_name(bufnr)
      local pdf_path = replace_extension(abs_path, "pdf")
      vim.system({
        "pandoc",
        "-s",
        "-V",
        "--dpi=300",
        "--slide-level=2",
        "-f",
        "markdown+fenced_divs+link_attributes+implicit_figures+smart",
        "--pdf-engine=lualatex",
        "--pdf-engine-opt=--shell-escape",
        -- "--listings",
        "-t",
        "beamer",
        abs_path,
        "-o",
        pdf_path,
      }, { text = true }, function(obj)
        if obj.code == 0 then
          if zathura[bufnr] == nil then
            zathura[bufnr] = true
            vim.system({ "zathura", pdf_path }, nil, function()
              zathura[bufnr] = nil
            end)
          end
        else
          vim.notify(obj.stderr, vim.log.levels.ERROR, { title = "pandoc" })
        end
      end)
    end
  end,
})

vim.keymap.set("n", "<leader>ll", function()
  enable_autocmd = not enable_autocmd
  local status = enable_autocmd and "enabled" or "disabled"
  vim.notify(string.format("Pandoc %s!", status), vim.log.levels.INFO)
end)

vim.keymap.set("n", "<leader>lv", function()
  vim.cmd [[ MarkdownPreviewToggle]]
end)

-- A table to keep track of Markdown URL nodes per buffer
__MarkdownURLNodes = {}

-- Toggles Markdown URL Nodes in Neovim.
-- It's used for concealing URL destinations in Markdown files.
-- [Link Text](Super Long Link Destination) and
-- [Link Text]( )
-- since concealing just replaces the long link Destination with whitespaces
local function toggle_url(query, opts)
  local ts = vim.treesitter
  opts = opts or {}
  opts.bufnr = vim.F.if_nil(opts.bufnr, api.nvim_get_current_buf())

  -- Initialize the Markdown URL Nodes for the buffer if it doesn't exist
  if not __MarkdownURLNodes[opts.bufnr] then
    __MarkdownURLNodes[opts.bufnr] = { enabled = false }
  end
  -- Get the nodes for the buffer
  local nodes = __MarkdownURLNodes[opts.bufnr]
  -- Toggle the enable status if not provided
  nodes.enabled = vim.F.if_nil(opts.enabled, not nodes.enabled)
  local enabled = nodes.enabled

  -- Create an augroup to manage auto commands for the URL concealer
  api.nvim_create_augroup("MarkdownLinkConcealer", { clear = true })

  -- Create pre-buffer write auto command to save markdown file with links
  api.nvim_create_autocmd("BufWritePre", {
    buffer = opts.bufnr,
    group = "MarkdownLinkConcealer",
    callback = function()
      local status = __MarkdownURLNodes[opts.bufnr].enabled
      toggle_url([[((link_destination) @node)]], { enabled = false, setup_autocmd = false })
      __MarkdownURLNodes[opts.bufnr].enabled = not status
    end,
  })

  -- Create post-buffer write auto command to restore state of toggling as before
  api.nvim_create_autocmd("BufWritePost", {
    buffer = opts.bufnr,
    group = "MarkdownLinkConcealer",
    callback = function()
      toggle_url([[((link_destination) @node)]], { setup_autocmd = false })
    end,
  })

  -- Cache syntax tree because parents node might "change"
  if not __MarkdownURLNodes.tree then
    opts.filetype = vim.F.if_nil(opts.filetype, vim.bo[opts.bufnr].filetype)
    local language_tree = ts.get_parser(opts.bufnr, "markdown_inline")
    __MarkdownURLNodes.tree = language_tree:parse()[1]
  end

  -- Work on the syntax tree
  local syntax_tree = __MarkdownURLNodes.tree
  local root = syntax_tree:root()
  local ts_query = ts.query.parse("markdown_inline", query)

  -- Iterate over all the captures
  for _, node, _ in ts_query:iter_captures(root, 1) do
    local parent = node:parent()
    local row1, col1, row2, col2 = node:range()
    if enabled then
      table.insert(nodes, { parent = parent, text = vim.deepcopy(ts.get_node_text(node, 0, nil)) })
      api.nvim_buf_set_text(0, row1, col1, row2, col2, { "" })
    else
      for _, entry in ipairs(nodes) do
        if parent:equal(entry.parent) then
          api.nvim_buf_set_text(0, row1, col1, row2, col2, { entry.text })
        end
      end
      __MarkdownURLNodes[opts.bufnr] = {}
    end
  end
end

vim.keymap.set("n", "<C-x>", function()
  toggle_url [[((link_destination) @node)]]
end)
