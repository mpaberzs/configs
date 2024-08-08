local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ff', function() builtin.git_files({ show_untracked = true, use_git_root = false }); end, {})

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
    }
  },
  pickers = {
    find_files = {
      additional_args = {
        "--smart-case",
      }
    },
    git_files = {
      additional_args = {
        "--smart-case",
      }
    },
  }
}
