vim.keymap.set("n", "<leader>gt", vim.cmd.Git)

vim.keymap.set("n", "<leader>gb", "<cmd>:Git blame<CR>")

vim.keymap.set("n", "<leader>gP", "<cmd>:Git pull<CR>")

vim.keymap.set("n", "<leader>gC", ":Git cherry-pick ")

vim.keymap.set("n", "<leader>gM", ":Git merge ")
vim.keymap.set("n", "<leader>gMM", "<cmd>:Git checkout master | Git pull | Git merge master | Git checkout -<CR>")
vim.keymap.set("n", "<leader>gMA", "<cmd>:Git checkout main | Git pull | Git merge main | Git checkout -<CR>")

-- git log
vim.keymap.set("n", "<leader>gl", "<cmd>:Gclog<CR>")
-- git log for file
vim.keymap.set("n", "<leader>glf", "<cmd>:Gclog %<CR>")

-- TODO: improve
vim.keymap.set("n", "<leader>gr", function()
  local current_path = vim.fn.expand("%")
  local new_path = vim.fn.input("New file path:\n", current_path)
  if new_path == "" then
    print('Received empty path, aborting...')
  else
    vim.cmd.GMove(new_path)
  end
end)
-- TODO
-- vim.g.fugitive_azure_devops_baseurl=
