-- Depends on tpope/vim-fugitive and lewis6991/gitsigns.nvim

vim.keymap.set('n', "<leader>gt", vim.cmd.Git)
-- FIXME: experimental "s" for status kind of makes more sense
vim.keymap.set('n', "<leader>gs", vim.cmd.Git)

vim.keymap.set('n', "<leader>gb", "<cmd>:Git blame<CR>")

vim.keymap.set('n', "<leader>gp", "<cmd>:Git pull<CR>")
vim.keymap.set('n', "<leader>gpM", "<cmd>:Git checkout master | Git pull<CR>")
vim.keymap.set('n', "<leader>gpA", "<cmd>:Git checkout main | Git pull<CR>")
vim.keymap.set('n', "<leader>gpD", "<cmd>:Git checkout dev | Git pull<CR>")

-- cherry-pick
vim.keymap.set('n', "<leader>gCP", ":Git cherry-pick --no-commit ")

-- checkout
vim.keymap.set('n', "<leader>gcb", ":Git checkout -b ")
vim.keymap.set('n', "<leader>gcc", ":Git checkout ")
vim.keymap.set('n', "<leader>gcA", ":Git checkout main<CR>")
vim.keymap.set('n', "<leader>gcM", ":Git checkout master<CR>")
vim.keymap.set('n', "<leader>gcD", ":Git checkout dev<CR>")
vim.keymap.set('n', "<leader>gc-", ":Git checkout -<CR>")

vim.keymap.set('n', "<leader>gaf", ":Git add %<CR>")

-- no hooks in current work context
-- vim.keymap.set('n', "<leader>gCM", ":Git commit -n")

vim.keymap.set('n', "<leader>gm", ":Git merge ")
vim.keymap.set('n', "<leader>gmM", ":Git merge master<CR>")
vim.keymap.set('n', "<leader>gmA", ":Git merge main<CR>")
vim.keymap.set('n', "<leader>gmD", ":Git merge dev<CR>")
vim.keymap.set('n', "<leader>gm-", ":Git merge -<CR>")
vim.keymap.set('n', "<leader>gms-", ":Git merge - --squash<CR>")
-- TODO: think about this
vim.keymap.set('n', "<leader>gMM", "<cmd>:Git checkout master | Git pull | Git checkout - | Git merge master<CR>")
vim.keymap.set('n', "<leader>gMA", "<cmd>:Git checkout main | Git pull | Git checkout - | Git merge main<CR>")

-- git log
vim.keymap.set('n', "<leader>gl", "<cmd>:Gclog<CR>")
-- git log for file
vim.keymap.set('n', "<leader>glf", "<cmd>:Gclog %<CR>")

-- TODO: improve
vim.keymap.set('n', "<leader>gr", function()
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
-- vim.keymap.set('n', "<leader>n", vim.cmd.Ex)
-- quick access without second key waiting timeout
vim.keymap.set('n', "<leader>nn", vim.cmd.Ex)
-- go to currently opened file dir
vim.keymap.set('n', "<leader>nf", "<cmd>cd %:h<CR>")
-- TODO: improve to have full path
-- copy current file path (relative to pwd)
vim.keymap.set('n', "<leader>ncl", "<cmd>! echo % | xsel -b > /dev/null 2>&1<CR>")
-- copy current file path (full path)
-- FIXME: experiment and decide on single keymap for this
vim.keymap.set('n', "<leader>ncf", "<cmd>! echo %:p | xsel -b > /dev/null 2>&1<CR>")
vim.keymap.set('n', "<leader>ncc", "<cmd>! echo %:p | xsel -b > /dev/null 2>&1<CR>")
-- go level back
vim.keymap.set('n', "<leader>n-", "<cmd>cd ..<CR>")
-- go to git root dir
vim.keymap.set('n', "<leader>ng", function()
  local git_root_dir = vim.api.nvim_command_output('Git rev-parse --show-toplevel')
  vim.cmd.cd(git_root_dir)
end)

-- TODO: rebase with fixup/reword/squash
-- TODO: cherry-pick
-- TODO: squash
-- TODO: get used to conflict resolving (2> 3> ... something like that)
-- TODO: could be in conjunction with git aliases


require('gitsigns').setup {
  signs                        = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged                 = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged_enable          = true,
  signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir                 = {
    follow_files = true
  },
  auto_attach                  = true,
  attach_to_untracked          = false,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority                = 6,
  update_debounce              = 100,
  status_formatter             = nil, -- Use default
  max_file_length              = 40000, -- Disable if file is longer than this (in lines)
  preview_config               = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  on_attach                    = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)


    map('n', '<leader>hS', gitsigns.stage_buffer)

    map('v', '<leader>gr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)
    map('n', '<leader>gR', gitsigns.reset_hunk)
    map('n', '<leader>gRR', gitsigns.reset_buffer)
    -- FIXME
    map('n', '<leader>GP', gitsigns.preview_hunk)
    map('n', '<leader>gi', gitsigns.preview_hunk_inline)

    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end)

    map('n', '<leader>hd', gitsigns.diffthis)

    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end)

    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
    map('n', '<leader>hq', gitsigns.setqflist)

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>td', gitsigns.toggle_deleted)
    map('n', '<leader>tw', gitsigns.toggle_word_diff)

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
  end
}
