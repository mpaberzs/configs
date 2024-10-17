vim.keymap.set("n", "<leader>DD", "<cmd>:DBUIToggle<CR>")

local op = require('op')
local json = require('cjson')

local str = op.get_secret('martins-neovim-databases-json', 'data')
local jsonData = string.sub(string.gsub(str, "\"\"", "\""), 2, -2)
local databases = json.decode(jsonData)

-- FIXME: acceptable for now but think about other solution where database url is a function executed only when db url is needed
vim.g.dbs = databases
