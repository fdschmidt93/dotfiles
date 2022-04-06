local auto_new_line = function(snip)
  return function(args, snippet)
    if #snippet.env.TM_CURRENT_LINE > #snippet.trigger then
      local ret = vim.deepcopy(snip)
      if type(ret) == "table" then
        table.insert(ret, "")
      else
        ret = { ret, "" }
      end
      return ret
    else
      return snip
    end
  end
end

return _,
  {
    s(
      { desc = "import torch", name = "torch", trig = ".t" },
      f(auto_new_line { "import torch", "import torch.nn as nn", "import torch.nn.functional as F" }),
      { condition = conds.line_begin }
    ),
    s({ desc = "import numpy", name = "np", trig = ".n" }, f(auto_new_line "import numpy as np"), {
      condition = conds.line_begin,
    }),
    s(
      { desc = "import dataset", name = "hf-ds", trig = ".Hd" },
      fmt(
        [[from datasets import load_dataset
{} = load_dataset("{}")]],
        { i(1, "d"), i(2) }
      ),
      {
        condition = conds.line_begin,
      }
    ),
    s(
      { desc = "import hf", name = "hf", trig = ".Hm" },
      fmt(
        [[from transformers import AutoModel{}, AutoTokenizer
m = AutoModel{}.from_pretrained("{}")
t = AutoTokenizer.from_pretrained("{}")]],
        {
          c(1, { t "", t "ForSequenceClassification", t "ForTokenClassification", t "ForMultipleChoice" }),
          rep(1),
          c(2, { t "xlm-roberta-base", t "roberta-base" }),
          rep(2),
        }
      ),
      {
        condition = conds.line_begin,
      }
    ),
    s(
      { desc = "dummy tensors", name = "hf", trig = ".Dt" },
      fmt(
        [[N, L, D = {}, {}, {}
alen = torch.randint(low=L-10, high=L, size=(N,))
mask = torch.arange(L) < alen[:, None]
mask = mask.long()
embeds = torch.randn((N, alen.shape[-1], D))
]],
        {
          i(1, "30"),
          i(2, "30"),
          i(3, "768"),
        }
      ),
      {
        condition = conds.line_begin,
      }
    ),
  }
