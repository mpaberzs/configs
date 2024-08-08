local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})

vim.keymap.set('n', '<leader>fs', function() 
  builtin.grep_string({ search = vim.fn.input("search string: ") }); 
end, {})

vim.keymap.set('n', '<leader>ff', function() 
  try_git_files = function() builtin.git_files({ show_untracked = true, use_git_root = false }); end
  try_find_files = function() builtin.find_files({}); end

  -- if not git dir then try to find regular files
  if pcall(try_git_files) then
  else
    try_find_files()
  end
end, {})

vim.keymap.set('n', '<leader>fdf', function() 
  builtin.git_files({ show_untracked = true, use_git_root = false, cwd = vim.fn.input("files in dir: ") }); 
end, {})

vim.keymap.set('n', '<leader>fdw', function() 
  builtin.live_grep({ cwd = vim.fn.input("grep in dir: ") }); 
end, {})

vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
vim.keymap.set('n', 'gD', builtin.lsp_type_definitions, {})
vim.keymap.set('n', 'gr', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>q', builtin.diagnostics, {})
--vim.keymap.set('n', '<leader>gt', builtin.git_status, {})

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--case-sensitive"
    }
  }
}
