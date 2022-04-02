local ls = require "luasnip"
ls.config.set_config {
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
}

local s = ls.s
local i = ls.insert_node
local f = ls.function_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local conds = require "luasnip.extras.expand_conditions"

ls.add_snippets("tex", {
  s({ name = "textbf", trig = ";fn" }, fmt([[\footnote{{{}}}]], { i(1) })),
  s({ name = "textbf", trig = ";bf" }, fmt([[\textbf{{{}}}]], { i(1) })),
  s({ name = "textsc", trig = ";sc" }, fmt([[\textsc{{{}}}]], { i(1) })),
  s({ name = "texttt", trig = ";tt" }, fmt([[\texttt{{{}}}]], { i(1) })),
  s({ name = "textit", trig = ";it" }, fmt([[\textit{{{}}}]], { i(1) })),
  s({ name = "cite", trig = ".ce" }, fmt([[\cite{{{}}}]], { i(1) })),
  s({ name = "citep", trig = ".cp" }, fmt([[\citep{{{}}}]], { i(1) })),
  s({ name = "citet", trig = ".ct" }, fmt([[\citet{{{}}}]], { i(1) })),
  s({ name = "m$", trig = "$" }, fmt([[${}${}]], { i(1), i(2) })),
  s(
    { name = "enum", trig = "enum" },
    fmt(
      [[\begin{enumerate}
    \item <>
\end{enumerate}]],
      { i(1) },
      { delimiters = "<>" }
    ),
    { cond = conds.line_begin }
  ),
  s(
    { name = "beg", trig = "beg" },
    fmt(
      [[\begin{{{}}}
    {}
\end{{{}}}]],
      { i(1), i(2), rep(1) }
    ),
    { cond = conds.line_begin }
  ),
  s(
    { name = "sec", trig = "sec" },
    fmt([[\section{<>}\label{sec:<>}]], {
      i(1),
      f(function(args)
        -- args is list of lines in your snippet
        local sec_name = args[1][1]
        return sec_name:lower():gsub("%s+", "-")
      end, { 1 }),
    }, { delimiters = "<>" }),
    { cond = conds.line_begin }
  ),
  s(
    { name = "subsec", trig = "subsec" },
    fmt([[\section{{{}}}\label{{{}}}]], {
      i(1),
      f(function(args)
        -- args is list of lines in your snippet
        local sec_name = args[1][1]
        return sec_name:lower():gsub("%s+", "-")
      end, { 1 }),
    }),
    { cond = conds.line_begin }
  ),
}, { type = "autosnippets" })
