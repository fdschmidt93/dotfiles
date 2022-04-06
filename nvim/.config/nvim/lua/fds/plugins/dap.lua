local opts = { silent = true }
local set = vim.keymap.set

local dap = require "dap"

set("n", "<space>Dc", dap.continue, opts)
set("n", "<F10>", dap.step_over, opts)
set("n", "<F11>", dap.step_into, opts)
set("n", "<F12>", dap.step_out, opts)
set("n", "<space>Db", dap.toggle_breakpoint, opts)
set("n", "<space>De", dap.repl.open, opts)
set("n", "<space>Dr", dap.run_to_cursor, opts)
set("n", "<space>Dl", dap.run_last, opts)
set("n", "<space>Dt", dap.terminate, opts)
-- send to dap repl ala vim-slime
set("v", "<C-r><C-r>", function()
  local selection = table.concat(require("fds.utils").visual_selection(), "\n")
  local session = require("dap").session()
  session:evaluate(selection, function(err)
    if err then
      require("dap.repl").append(err.message)
      return
    end
  end)
  require("dap.repl").append(selection)
  -- scroll dap repl to bottom
  local repl_buf = vim.tbl_filter(function(b)
    if vim.bo[b].filetype == "dap-repl" then
      return true
    end
    return false
  end, vim.api.nvim_list_bufs())[1]
  -- deferring since otherwise too early
  vim.defer_fn(function()
    vim.api.nvim_buf_call(repl_buf, function()
      vim.cmd [[normal! G]]
    end)
  end, 50)
end)

-- dapui panes don't readjust nicely in height and get distored easily
-- this will ensure panes are always toggled with evenly spread height
set("n", "<space>Du", function()
  require("dapui").toggle()
  vim.defer_fn(function()
    local dapui_wins = vim.tbl_filter(function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      return string.find(vim.bo[buf].filetype, "dapui_") ~= nil
    end)
    local num_wins = #dapui_wins
    if num_wins > 1 then
      local screen_height = vim.o.lines - 3
      local win_height = math.floor(screen_height / 4)
      for _, win in ipairs(dapui_wins) do
        vim.api.nvim_win_set_height(win, win_height)
      end
    end
  end, 25)
end)
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Breakpoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "Stopped" })
require("telescope").load_extension "dap"

-- autocompletion
vim.api.nvim_create_autocmd("FileType", { pattern = "dap-repl", callback = require("dap.ext.autocompl").attach })
