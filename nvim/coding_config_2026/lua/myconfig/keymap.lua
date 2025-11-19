-- virtualedit is useful for multiline editing
vim.keymap.set('n', "<leader>va", function() vim.opt.virtualedit = "all" end)
vim.keymap.set('n', "<leader>vn", function() vim.opt.virtualedit = "none" end)

-- copying to system clipboard and pasting from it
vim.keymap.set('v', "<leader>c", '"+y')
-- copy whole line
vim.keymap.set('n', "<leader>c", '"+yy')
-- paste
vim.keymap.set('n', "<leader>p", '"+p')
vim.keymap.set('n', "<leader>P", '"+P')
vim.keymap.set('v', "<leader>p", '"+p')

-- initiate operation retaining " buffer
vim.keymap.set('n', "<leader>a", '"_')

-- allows to move selection around
vim.keymap.set('v', "J", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'vi{', 'vi{o')
vim.keymap.set('n', 'vi}', 'vi{o')

-- don't move cursor when J
vim.keymap.set('n', "J", "mzJ`z")

-- Q is evil appearently
vim.keymap.set('n', "Q", "<nop>")

-- centered search results
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzzv")

vim.keymap.set('n', "<leader>TN", "<cmd>:tabnew<CR>")
vim.keymap.set('n', "<leader>TX", "<cmd>:tabclose<CR>")

-- close buffer
vim.keymap.set('n', "<leader>x", "<cmd>:bd<CR>")
vim.keymap.set('n', "<leader><C-x>", "<cmd>:bd!<CR>")

-- close all buffers
vim.keymap.set('n', "<leader>X", "<cmd>:%bd<CR>")
vim.keymap.set('n', "<leader><C-X>", "<cmd>:%bd!<CR>")

-- classic save shortcut
vim.keymap.set('n', "<C-s>", "<cmd>:w<CR>")

-- save all buffers
vim.keymap.set('n', "<C-M-s>", "<cmd>:bufdo w<CR>")

-- save as
vim.keymap.set('n', "<C-S-s>", ":sav ")

-- bind ctrl+c as confirm (for block edits)
vim.keymap.set("i", "<C-c>", "<Esc>")

-- clear highlights
vim.keymap.set('n', "<leader>sx", ":noh<CR>")

-- single button to get into COMMAND mode
vim.keymap.set('n', ";", ":")
-- quick way to get into COMMAND mode to execute shell CMD
vim.keymap.set('n', "<leader>;", ":!")

-- reload buffer
vim.keymap.set('n', "<leader>e", ":e<CR>")
