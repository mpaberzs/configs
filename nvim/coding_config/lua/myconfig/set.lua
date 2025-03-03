vim.g.mapleader      = " "
vim.g.maplocalleader = "\\"

vim.opt.guicursor    = ""

vim.opt.tabstop      = 2
vim.opt.softtabstop  = 2
vim.opt.shiftwidth   = 2
vim.opt.expandtab    = true
--
-- sometimes need bigger font
-- vim.o.guifont = "Nerd Font:h18"
-- sometimes smaller
-- vim.o.guifont = "Nerd Font:h16"

vim.opt.ignorecase    = false
vim.opt.smartcase     = false

vim.opt.hlsearch      = true
vim.opt.incsearch     = true

vim.opt.termguicolors = true
-- pre scroll lines up/down when moving in the file vertically
vim.opt.scrolloff     = 8

vim.opt.updatetime    = 50
vim.opt.signcolumn    = "yes"

-- not needed currently
-- vim.opt.timeoutlen = 1000

vim.opt.smartindent    = true
-- relative line num by default
vim.opt.nu             = true
vim.opt.relativenumber = true

-- break line or go infinitely to the right, seems I mostly want that break but maybe should be togglable
vim.opt.wrap     = true
vim.opt.swapfile = false
vim.opt.backup   = false
vim.opt.undodir  = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

if vim.g.neovide then
  -- don't show drunken cursor animation
  vim.g.neovide_cursor_animation_length       = 0.0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_scroll_animation_length       = 0.0
end

vim.filetype.add({
  filename = {
    ['Dockerfile-frontend-prod'] = 'dockerfile',
    ['Dockerfile-backend-prod'] = 'dockerfile',
    ['Dockerfile-prod'] = 'dockerfile',
  }
})
