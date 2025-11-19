-- live templates
-- TODO: very clumsy - improve or maybe use plugin?
vim.keymap.set("n", "<leader>tttd", ":s/^/describe\\('', \\(\\) => \\{\\r\\}\\);<CR>:noh<CR>kf'a")
vim.keymap.set("n", "<leader>tttt", ":s/^/it\\('', \\(\\) => \\{\\r\\}\\);<CR>:noh<CR>kf'a")
vim.keymap.set("n", "<leader>ttte", ":s/^/expect\\(x\\)\\.toEqual\\(\\);<CR>:noh<CR>^fxfxcw")
vim.keymap.set("n", "<leader>tte", ":s/^/export class x extends Error \\{\\}<CR>:noh<CR>^fxfxcw")
vim.keymap.set("n", "<leader>ttc", ":s/^/export class x \\{\\}<CR>:noh<CR>^fxfxcw")
vim.keymap.set("n", "<leader>ttf", ":s/^/const x = \\(\\) => \\{\\r\\};<CR>:noh<CR>kfxcw")
vim.keymap.set("n", "<leader>ttfa", ":s/^/\\(\\) => \\{\\r\\}<CR>:noh<CR>k")

vim.keymap.set("n", "<leader>trtm", ":s/^/#[cfg\\(test\\)]\\rmod tests {\\r    #[test]\\r    fn test\\(\\) {\\r    }\\r}<CR>:noh<CR>kO")
