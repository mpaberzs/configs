vim.keymap.set("n", "<leader>gt", vim.cmd.Git)
vim.keymap.set("n", "<leader>gb", "<cmd>:Git blame<CR>")
vim.keymap.set("n", "<leader>gl", "<cmd>:Gclog<CR>")
vim.keymap.set("n", "<leader>glf", "<cmd>:Gclog %<CR>")
-- TODO: improve
vim.keymap.set("n", "<leader>gr", ":GMove " .. vim.fn.expand("%"))
-- vim.keymap.set("n", "<leader>gr", function()
  -- local current_path = vim.fn.expand("%")
  -- local new_path = vim.fn.input("New file path:\n", current_path)
  -- if new_path == "" then
  --   print('Received empty path, aborting...')
  -- else
  --   vim.cmd.GMove(new_path)
  -- end
-- end)
