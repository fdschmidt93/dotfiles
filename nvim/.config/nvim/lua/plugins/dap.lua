return {
  "mfussenegger/nvim-dap",
  keys = "<space>D",
  dependencies = {
    "nvim-telescope/telescope-dap.nvim",
    { "rcarriga/nvim-dap-ui" },
    { "mfussenegger/nvim-dap-python" },
  },
  config = function()
    local set = vim.keymap.set

    local dap = require "dap"

    -- text str: lines concatenated with \n
    local send_to_repl = function(text)
      local session = dap.session()
      session:evaluate(text, function(err)
        if err then
          require("dap.repl").append(err.message)
          return
        end
      end)
      require("dap.repl").append(text)
      -- scroll dap repl to bottom
      local repl_buf = vim.tbl_filter(function(b)
        return vim.bo[b].filetype == "dap-repl"
      end, vim.api.nvim_list_bufs())[1]
      -- deferring since otherwise too early
      vim.defer_fn(function()
        vim.api.nvim_buf_call(repl_buf, function()
          vim.cmd [[normal! G]]
        end)
      end, 50)
    end

    set("n", "<space>Dc", dap.continue, { desc = "DAP: continue" })
    set("n", "<F10>", dap.step_over, { desc = "DAP: step over" })
    set("n", "<F11>", dap.step_into, { desc = "DAP: step into" })
    set("n", "<F12>", dap.step_out, { desc = "DAP: step out" })
    set("n", "<space>Db", dap.toggle_breakpoint, { desc = "DAP: toggle breakpoint" })
    set("n", "<space>De", dap.repl.open, { desc = "DAP: open repl" })
    set("n", "<space>Dr", dap.run_to_cursor, { desc = "DAP: run to cursor" })
    set("n", "<space>Dl", dap.run_last, { desc = "DAP: run last" })
    set("n", "<space>Dt", dap.terminate, { desc = "DAP: terminate" })
    -- send to dap repl ala vim-slime
    set("v", "<C-r><C-r>", function()
      local selection = table.concat(require("fds.utils").visual_selection(), "\n")
      send_to_repl(selection)
    end)
    set("v", "<C-r>k", function()
      local selection = table.concat(require("fds.utils").visual_selection(), "\n")
      if #selection > 1 then
        error "Inspecting variables only works with single lines"
      end
      selection = string.format([[print(%s)]], selection[1])
      send_to_repl(selection)
    end)
    set({ "n", "v" }, "<C-r>k", function()
      local selection
      local mode = vim.api.nvim_get_mode().mode
      if mode == "n" then
        selection = vim.fn.expand "<cword>"
      else
        selection = table.concat(require("fds.utils").visual_selection(), "\n")
        if type(selection) == "table" then
          if #selection > 1 then
            error "Inspecting variables only works with single lines"
            return
          end
          selection = selection[1]
        end
      end
      send_to_repl(string.format([[print(%s)]], selection))
    end)
    set({ "n", "v" }, "<C-r>s", function()
      local selection
      local mode = vim.api.nvim_get_mode().mode
      if mode == "n" then
        selection = vim.fn.expand "<cword>"
      else
        selection = table.concat(require("fds.utils").visual_selection(), "\n")
        if type(selection) == "table" then
          if #selection > 1 then
            error "Inspecting variables only works with single lines"
            return
          end
          selection = selection[1]
        end
      end
      send_to_repl(string.format([[print(%s.shape)]], selection))
    end)

    -- dapui panes don't readjust nicely in height and get distored easily
    -- this will ensure panes are always toggled with evenly spread height
    set("n", "<space>Du", function()
      require("dapui").toggle()
      vim.defer_fn(function()
        local dapui_wins = vim.tbl_filter(function(win)
          local buf = vim.api.nvim_win_get_buf(win)
          return string.find(vim.bo[buf].filetype, "dapui_") ~= nil
        end, vim.api.nvim_list_wins())
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
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "dap-repl",
      callback = function()
        require("dap.ext.autocompl").attach()
      end,
    })

    local python_path = string.format("/home/%s/miniconda3/bin/python", vim.env.USER)
    require("dap-python").setup(python_path)
    require("dapui").setup()
  end,
}
