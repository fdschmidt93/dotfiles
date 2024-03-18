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
            vim.system({ "zathura", pdf_path }, nil, function() zathura[bufnr] = nil end)
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

vim.keymap.set("n", "<leader>lv", function() vim.cmd [[ MarkdownPreviewToggle]] end)

vim.keymap.set("n", "gf", function()
  -- TODO: work this in
  --     links.followLink = function(path, anchor)
  --       if path or anchor then
  --         path, anchor = path, anchor
  --       else
  --         path, anchor, _ = links.getLinkPart(links.getLinkUnderCursor(), "source")
  --       end
  --       local uri = "phd://"
  --       if path:find(uri) then
  --         vim.system { "xdg-open", path }
  --         return
  --       end
  --       followLink(path, anchor)
  --     end
  if require("obsidian").util.cursor_on_markdown_link() then
    return "<cmd>ObsidianFollowLink<CR>"
  else
    return "gf"
  end
end, { buffer = 0, noremap = false, expr = true })

vim.wo[0].conceallevel = 2
