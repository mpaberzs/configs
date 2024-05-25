-- TODO

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
