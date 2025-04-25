-- file browser
vim.keymap.set("n", "<leader>n", vim.cmd.Ex)
-- virtualedits are useful for mass editing
vim.keymap.set("n", "<leader>va", function() vim.opt.virtualedit = "all" end)
vim.keymap.set("n", "<leader>vn", function() vim.opt.virtualedit = "none" end)

-- TODO: think of a binding that makes sense
-- vim.keymap.set("n", "<leader>vn", "<cmd>cd %:h<CR>")

-- copying to system clipboard and pasting from it
vim.keymap.set("v", "<leader>c", '"+y')
vim.keymap.set("n", "<leader>c", 'viw"+y')
vim.keymap.set("n", "<leader>p", '"+p')

-- TODO: mapping for this - operations retaining " buffer
-- vim.keymap.set("n", "<leader>p", '"_dP')

-- allows to move selection around
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'vi{', 'vi{o')
vim.keymap.set('n', 'vi}', 'vi{o')
-- for selecting higher order block
-- FIXME doesnt work properly, for some cases works, for others not
vim.keymap.set("v", "{", "v<cmd>'<,'>?{<CR>n<cmd>:noh<CR>vi{o")
vim.keymap.set("v", "}", "v<cmd>'<,'>/{<CR>N<cmd>:noh<CR>vi{o")

-- don't move cursor when J
vim.keymap.set("n", "J", "mzJ`z")

-- Q is evil appearently
vim.keymap.set("n", "Q", "<nop>")

-- centered search results
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format() end)
-- format with prettier
-- FIXME: lang dependent
vim.keymap.set("n", "<leader>F", "mf<cmd>%! prettier --parser=typescript || LspZeroFormat <CR>`f")

vim.keymap.set("n", "<leader>T", "<cmd>:tabnew<CR>")

-- cycle through buffers using tab
vim.keymap.set("n", "<Tab>", "<cmd>:bn<CR>")

-- cycle through tabs using leader + TAB
vim.keymap.set("n", "<leader><Tab>", "<cmd>:tabnext<CR>")

-- close buffer
vim.keymap.set("n", "<leader>x", "<cmd>:bd<CR>")

-- classic save shortcut
vim.keymap.set("n", "<C-s>", "<cmd>:w<CR>")

-- TODO: classic save as shortcut -- does not work
vim.keymap.set("n", "<leader>wa", "<cmd>:wa<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>:w<CR>")
vim.keymap.set("n", "<leader>ws", ":sav ")

-- bind ctrl+c as save (for block edits)
vim.keymap.set("i", "<C-c>", "<Esc>")

-- search the word under the cursor
vim.keymap.set("n", "<leader>s", ":sno/")
vim.keymap.set("n", "<leader>ss", ":sno/")
vim.keymap.set("n", "<leader>sw", ":sno/\\<<C-r><C-w>\\><Left><Left>")
-- clear highlights
vim.keymap.set("n", "<leader>sx", ":noh<CR>")

vim.keymap.set("n", "<leader>S", ":%sno/")
-- search-replace the word under the cursor
vim.keymap.set("n", "<leader>Sw", ":%sno/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

vim.keymap.set("n", "<leader>vf", "^vf{%")
-- TODO: investigate why "^f}v%^" does not work
vim.keymap.set("n", "<leader>Vf", "v%^")

-- vim.keymap.set("n", "<leader>X", ":bufdo bd<CR>")
vim.keymap.set("n", "<leader>X", ":qa<CR>")
-- vim.keymap.set("n", "", "<cmd>:messages")
