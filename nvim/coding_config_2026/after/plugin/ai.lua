local init_setup = function ()
  -- TODO: would it be possible to attempt to use system secrets manager (e.g. gnome-keyring) which would point to 1pass or maybe env file which would have op:// or other respective bindings?
  -- local openApiKey = op.get_secret('martins-openai-api-key', 'data')
  local openApiKey = ""
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

-- TODO: ability to use GP not even opening the window (maybe <leader>hi to insert following a prompt and <leader>hr to replace following an inserted prompt)
-- TODO: read again about built in functions (the ones also at the bottom of this file)

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
