-- initiate config lazily so don't have to enter 1pass password on neovim startup
local init_setup = function ()
  local op = require('op')
  local openApiKey = op.get_secret('martins-openai-api-key', 'data')
  -- local openApiKey = ""
  local conf = {
    -- For customization, refer to Install > Configuration in the Documentation/Readme
    openai_api_key = openApiKey,
    providers = {
      openai = {
        disable = false,
        endpoint = "https://api.openai.com/v1/chat/completions",
        secret = openApiKey,
      },
    },
    agents = {
      {
        provider = 'openai',
        name = "ChatGPT4o",
        chat = true,
        command = true,
        -- string with model name or table with model name and parameters
        model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
        -- system prompt (use this to specify the persona/role of the AI)
        system_prompt = require("gp.defaults").chat_system_prompt,
      }
    }
  }
  require("gp").setup(conf)
end

local setupDone = false

vim.keymap.set("n", "<leader>hc", function()
  if not setupDone then
    init_setup()
  end
  vim.cmd('GpChatNew')
end)

vim.keymap.set("v", "<leader>hc", function()
  if not setupDone then
    init_setup()
  end
  vim.cmd("'<,'>GpChatNew")
end)
-- vim.keymap.set("v", "<leader>hc", "<cmd>:'<,'>GpChatNew<CR>")
--
-- vim.keymap.set("n", "<leader>hl", "<cmd>:GpChatFinder<CR>")
-- vim.keymap.set("v", "<leader>hp", "<cmd>:GpChatPaste<CR>")
-- vim.keymap.set("v", "<leader>hr", "<cmd>:GpRewrite<CR>")
-- vim.keymap.set("n", "<leader>hx", "<cmd>:GpStop<CR>")
-- vim.keymap.set("v", "<leader>hx", "<cmd>:GpStop<CR>")
