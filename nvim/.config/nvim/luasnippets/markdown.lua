local function extract_pdf_url(str)
  -- This pattern matches a string that starts with "pdf-url=", followed by a URL
  -- The URL pattern is as follows:
  -- "https://" followed by one or more alphanumeric characters, periods, hyphens,
  -- underscores, slashes, equals signs, ampersands, question marks, colons, and hash signs.
  -- Let's break down the URL pattern:
  -- The entire URL is captured by the double parentheses for use after the match
  -- Note: This is a simple pattern and may not cover all possible valid URLs, but it covers a wide range of typical ones.
  local pdf_url = string.match(str, "pdf%-url=((https://[%w%.%-_/=&?#:]+))")
  return pdf_url
end

local function get_url(path)
  local out = vim
    .system({
      "exiftool",
      "-s3",
      "-Keywords",
      path,
    })
    :wait()
  return extract_pdf_url(out.stdout)
end

return nil,
  {
    s({ name = "textbf", trig = ";bf" }, fmt([[**{}**]], { i(1) })),
    s({ name = "texttt", trig = ";tt" }, fmt([[`{}`]], { i(1) })),
    s({ name = "textit", trig = ";it" }, fmt([[*{}*]], { i(1) })),
    s(
      { name = "paper_link", trig = ";pp" },
      fmt([=[{}[{}](<phd://open-pdf/{}{}{}>){}]=], {
        i(4),
        d(2, function(args)
          return sn(nil, i(1, args[1]))
        end, { 1 }),
        d(1, function()
          local papers = {}
          for name, _ in vim.fs.dir "/home/fdschmidt/phd/papers/" do
            papers[#papers + 1] = name
          end
          for i, p in ipairs(papers) do
            papers[i] = t(p)
          end
          return sn(nil, c(1, papers))
        end),
        f(function(args)
          if args then
            local page = args[1]
            if page then
              page = page[1]
              if type(page) == "string" and #page >= 1 then
                return "/"
              end
            end
          end
          return ""
        end, { 3 }),
        i(3),
        i(0),
      })
    ),
    s(
      { name = "paper-link", trig = ";pu" },
      fmt([=[{}[{}]({}){}]=], {
        i(3),
        d(1, function()
          local papers = {}
          for name, _ in vim.fs.dir "/home/fdschmidt/phd/papers/" do
            papers[#papers + 1] = name
          end
          for i, p in ipairs(papers) do
            papers[i] = t(p)
          end
          return sn(nil, c(1, papers))
        end),
        d(2, function(args, _, old_state)
          old_state = vim.F.if_nil(old_state, {})
          -- need to cache path in case we change the input to a non-paper
          if args[1] or old_state.url ~= nil then
            local url
            local path = string.format([[/home/fdschmidt/phd/papers/%s]], args[1][1])
            if path and vim.fn.filereadable(path) == 1 then
              url = get_url(path)
              old_state.url = url
            else
              url = vim.F.if_nil(old_state.url, "")
            end
            local snip = sn(nil, i(1, url))
            snip.old_state = old_state
            return snip
          end
          return sn(nil, i(1))
        end, { 1 }),
        i(0),
      })
    ),
  }
