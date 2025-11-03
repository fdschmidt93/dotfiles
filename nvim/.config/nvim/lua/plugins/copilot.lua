local API_KEY = os.getenv("COHERE_API_KEY")

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master"

      },
      {
        "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
      },
    },
    -- build = "make tiktoken",
    config = function()
      require("CopilotChat").setup {
        -- See Configuration section for options
        -- model = "command-a-03-2025", -- AI model to use
        model = "gpt-5",         -- AI model to use
        temperature = 0.1,       -- Lower = focused, higher = creative
        window = {
          layout = "vertical",   -- 'vertical', 'horizontal', 'float'
          width = 0.5,           -- 50% of screen width
        },
        auto_insert_mode = true, -- Enter insert mode when opening
        providers = {
          cohere = {
            prepare_input = function(...)
              local out = require("CopilotChat.config.providers").copilot.prepare_input(...)
              out.n = nil -- cohere api doesn't support that
              out.stream = true
              return out
            end,
            prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

            get_url = function() return "https://stg.api.cohere.ai/compatibility/v1/chat/completions" end,

            get_headers = function()
              vim.print(API_KEY)
              local api_key = API_KEY
              return {
                Authorization = "Bearer " .. api_key,
                ["Content-Type"] = "application/json",
              }
            end,
            get_models = function()
              return {
                { id = "command-a-03-2025",           name = "Command A" },
                { id = "command-a-reasoning-08-2025", name = "Command A (Reasoning)" },
              }
            end,
          },
        },
      }
      local model = "command-a-03-2025"
      vim.keymap.set(
        "n",
        "<leader><leader>xf",
        function()
          require("CopilotChat").ask([[What does this file do?]], {
            model = model,
            selection = require("CopilotChat.select").buffer,
          })
        end
      )
      vim.keymap.set({ "n", "v" }, "<leader><leader>xc", function()
        require("CopilotChat").ask([[Briefly explain the context.]], {
          selection = function(source)
            -- visual selection or otherwise current line
            return require("CopilotChat.select").visual(source) or require("CopilotChat.select").line(source)
          end,
          model = model,
        })
      end)
      vim.keymap.set(
        { "n" },
        "<leader><leader>df",
        function()
          require("CopilotChat").ask([[Do you see anything wrong with this file?]], {
            selection = require("CopilotChat.select").buffer,
            model = model,
          })
        end
      )
      vim.keymap.set({ "n", "v" }, "<leader><leader>dc", function()
        require("CopilotChat").ask([[Do you see anything wrong with this context?]], {
          selection = function(source)
            -- visual selection or otherwise current line
            return require("CopilotChat.select").visual(source) or require("CopilotChat.select").line(source)
          end,
          model = model,
        })
      end)
    end,
  },
}
