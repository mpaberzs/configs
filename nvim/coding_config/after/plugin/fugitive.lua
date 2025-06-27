vim.keymap.set("n", "<leader>gt", vim.cmd.Git)
-- FIXME: experimental "s" for status kind of makes more sense
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

vim.keymap.set("n", "<leader>gb", "<cmd>:Git blame<CR>")

vim.keymap.set("n", "<leader>gP", "<cmd>:Git pull<CR>")
vim.keymap.set("n", "<leader>gPM", "<cmd>:Git checkout master | Git pull<CR>")
vim.keymap.set("n", "<leader>gPA", "<cmd>:Git checkout main | Git pull<CR>")

vim.keymap.set("n", "<leader>gCP", ":Git cherry-pick --no-commit ")
vim.keymap.set("n", "<leader>gCB", ":Git checkout -b ")
vim.keymap.set("n", "<leader>gCC", ":Git checkout ")

vim.keymap.set("n", "<leader>gCM", ":Git commit -n")

vim.keymap.set("n", "<leader>gM", ":Git merge ")
vim.keymap.set("n", "<leader>gMM", "<cmd>:Git checkout master | Git pull | Git checkout - | Git merge master<CR>")
vim.keymap.set("n", "<leader>gMA", "<cmd>:Git checkout main | Git pull | Git checkout - | Git merge main<CR>")

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

-- these bindings are here because some are fugitive related
-- file browser (netrw)
-- vim.keymap.set("n", "<leader>n", vim.cmd.Ex)
-- quick access without second key waiting timeout
vim.keymap.set("n", "<leader>nn", vim.cmd.Ex)
-- go to currently opened file dir
vim.keymap.set("n", "<leader>nf", "<cmd>cd %:h<CR>")
-- TODO: improve to have full path
-- copy current file path
vim.keymap.set("n", "<leader>nc", "<cmd>! echo % | xsel -b > /dev/null 2>&1<CR>")
-- go level back
vim.keymap.set("n", "<leader>n-", "<cmd>cd ..<CR>")
-- go to git root dir
vim.keymap.set("n", "<leader>ng", function()
  local git_root_dir = vim.api.nvim_command_output('Git rev-parse --show-toplevel')
  vim.cmd.cd(git_root_dir)
end)
