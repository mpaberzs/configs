local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})

vim.keymap.set('n', '<leader>fs', function() 
  builtin.grep_string({ search = vim.fn.input("search string: ") });
end, {})

vim.keymap.set('n', '<leader>ff', function() 
  try_git_files = function() builtin.git_files({ show_untracked = true, use_git_root = false }); end
  try_find_files = function() builtin.find_files({ hidden = true }); end

  -- if not git dir then try to find regular files
  if pcall(try_git_files) then
  else
    try_find_files()
  end
end, {})

-- TODO: does not work correctly (e.g. scripts dir)
vim.keymap.set('n', '<leader>fdf', function()
  local result = vim.fn['FugitiveIsGitDir']()
  if result ~= '' then
    local cwd = vim.fn.input("files in dir: ")
    builtin.find_files({ hidden = true, cwd })
  else
    local cwd = vim.fn.input("files in dir: ")
    builtin.git_files({ show_untracked = true, use_git_root = false, cwd })
  end
end, {})

vim.keymap.set('n', '<leader>fdw', function() 
  builtin.live_grep({ cwd = vim.fn.input("grep in dir: ") });
end, {})

vim.keymap.set("n", "<leader>sf", function()
  local search_file = vim.fn.expand("<cword>")

  -- try_git_files = function() builtin.git_files({ find_command = {'git', 'ls-files', 'grep', search_file}, show_untracked = true, use_git_root = false }); end
  try_find_files = function() builtin.find_files({ search_file = search_file, hidden = true }); end

  -- TODO: can I still use git_files somehow?
  try_find_files()
end)

vim.keymap.set("n", "<leader>sdw", function()
  local search = vim.fn.expand("<cword>")
  builtin.live_grep({ default_text = search, cwd = vim.fn.input("grep in dir: ") }); 
end)

-- TODO
-- vim.keymap.set("v", "<leader>sdw", function()
--   local search = vim.fn.expand("'<,'>")
--   builtin.live_grep({ default_text = search, cwd = vim.fn.input("grep in dir: ") }); 
-- end)

vim.keymap.set('n', '<leader>b', builtin.buffers, {})
-- Looks not useful? Shows non related context
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
vim.keymap.set('n', 'gD', builtin.lsp_type_definitions, {})
vim.keymap.set('n', 'gr', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>q', builtin.diagnostics, {})
-- grep the word under the cursor
-- vim.keymap.set("n", "<leader>sfw", function()
--   local search = vim.fn.expand("<cword>")
--   builtin.live_grep({ default_text=search });
-- end)

vim.keymap.set("n", "<leader>sdw", function()
  local search = vim.fn.expand("<cword>")
  builtin.live_grep({ default_text = search, cwd = vim.fn.input("grep in dir: ") }); 
end)
-- search-replace the word under the cursor
-- TODO
-- vim.keymap.set("n", "<leader>Sw", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

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
