-- live templates
-- TODO: very clumsy - improve or maybe use plugin?
vim.keymap.set("n", "<leader>ttd", ":s/^/describe\\('', \\(\\) => \\{\\r\\}\\);<CR>:noh<CR>kf'a")
vim.keymap.set("n", "<leader>ttt", ":s/^/it\\('', \\(\\) => \\{\\r\\}\\);<CR>:noh<CR>kf'a")
vim.keymap.set("n", "<leader>tte", ":s/^/expect\\(x\\)\\.toEqual\\(\\);<CR>:noh<CR>^fxfxcw")
vim.keymap.set("n", "<leader>te", ":s/^/export class x extends Error \\{\\}<CR>:noh<CR>^fxfxcw")
vim.keymap.set("n", "<leader>tc", ":s/^/export class x \\{\\}<CR>:noh<CR>^fxfxcw")
vim.keymap.set("n", "<leader>tf", ":s/^/const x = \\(\\) => \\{\\r\\};<CR>:noh<CR>kfxcw")
vim.keymap.set("n", "<leader>tfa", ":s/^/\\(\\) => \\{\\r\\}<CR>:noh<CR>k")
