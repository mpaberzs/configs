-- TODO: improve, extend

function notesconfig()
  print("switching to notes config")
  vim.opt.spell = true
  -- TODO: disable auto-completion popup
end

function codingconfig()
  print("switching to coding config")
  vim.opt.spell = false
end

vim.keymap.set("n", "<leader>cn", notesconfig)
vim.keymap.set("n", "<leader>cc", codingconfig)


vim.api.nvim_buf_create_user_command(
  0, -- current buffer
  'MyNotesConfig',
  notesconfig,
  {
    bang = true,
    nargs = '?',
    desc = 'Switch to notes config'
  }
)

vim.api.nvim_buf_create_user_command(
  0, -- current buffer
  'MyCodingConfig',
  codingconfig,
  {
    bang = true,
    nargs = '?',
    desc = 'Switch to coding config'
  }
)
