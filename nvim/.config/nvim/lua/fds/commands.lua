local api = vim.api

api.nvim_create_user_command("PythonTerm", function()
  vim.cmd.lcd "/tmp/"
  api.nvim_buf_set_name(0, string.format("/tmp/%s.py", tostring(os.time())))
  vim.bo[0].filetype = "python"
  require("fds.utils.repl").toggle_termwin "right"
  vim.defer_fn(function()
    local imports = {
      "from transformers import AutoModel, AutoTokenizer",
      "import numpy as np",
      "import pandas as pd",
      "import torch",
      "import torch.nn as nn",
      "import torch.nn.functional as F",
    }
    local data = {}
    for _, line in ipairs(imports) do
      table.insert(data, "try:")
      table.insert(data, "    " .. line)
      table.insert(data, "except:")
      table.insert(data, "    pass")
    end
    table.insert(data, "%clear")
    require("resin.api").send { data = data, history = false }
    vim.api.nvim_buf_set_lines(0, 0, -1, false, imports)
    vim.api.nvim_win_set_cursor(0, { #imports, 0 })
  end, 750)
end, {})
