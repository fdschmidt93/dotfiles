local Job = require "plenary.job"
local Path = require "plenary.path"

local zathura = {}
local enable_autocmd = false

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

vim.api.nvim_create_augroup("Pandoc", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.md",
  group = "Pandoc",
  callback = function()
    if enable_autocmd then
      local bufnr = vim.api.nvim_get_current_buf()
      local abs_path = vim.api.nvim_buf_get_name(bufnr)
      local pdf_path = replace_extension(abs_path, "pdf")
      local pandoc = Job:new { command = "pandoc", args = { abs_path, "-t", "beamer", "-o", pdf_path } }
      pandoc:after_success(function()
        if zathura[bufnr] == nil then
          zathura[bufnr] = Job:new { command = "zathura", args = { pdf_path } }
          zathura[bufnr]:start()
        end
      end)
      pandoc:start()
    end
  end,
})

vim.keymap.set("n", "<leader>ll", function()
  enable_autocmd = not enable_autocmd
  local status = enable_autocmd and "enabled" or "disabled"
  vim.notify(string.format("Pandoc %s!", status), vim.log.levels.INFO)
end)
