-- file browser
vim.keymap.set("n", "<leader>n", vim.cmd.Ex)
-- virtualedits are useful for mass editing
vim.keymap.set("n", "<leader>va", function() vim.opt.virtualedit = "all" end)
vim.keymap.set("n", "<leader>vn", function() vim.opt.virtualedit = "none" end)

-- allows to move selection around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- don't move cursor when J
vim.keymap.set("n", "J", "mzJ`z")

-- Q is evil appearently
vim.keymap.set("n", "Q", "<nop>")

-- centered search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end)
-- format with prettier
-- TODO: lang dependent
vim.keymap.set("n", "<leader>f", "<cmd>%! prettier --parser=typescript || LspZeroFormat <CR>")

-- cycle through buffers using tab
vim.keymap.set("n", "<Tab>", "<cmd>:bn<CR>")

-- close buffer
vim.keymap.set("n", "<leader>x", "<cmd>:bd<CR>")

-- classic save shortcut
vim.keymap.set("n", "<C-s>", "<cmd>:w<CR>")

-- TODO: classic save as shortcut -- does not work
vim.keymap.set("n", "<Shift-C-s>", ":sav")

-- bind ctrl+c as save (for block edits)
vim.keymap.set("i", "<C-c>", "<Esc>")

-- search the word under the cursor
vim.keymap.set("n", "<leader>s", ":/\\<<C-r><C-w>\\><Left><Left><Left>")

-- search-replace the word under the cursor
vim.keymap.set("n", "<leader>S", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.keymap.set("n", "<leader>vf", "^vf{%")
-- TODO: investigate why "^f}v%^" does not work
vim.keymap.set("n", "<leader>Vf", "v%^")

