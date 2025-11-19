-- https://zignar.net/2022/01/21/a-boring-statusline-for-neovim/ -- a fork with some changes -- he has never statusline now - maybe take a look
--
-- TODO: hide on fugitive window

local M = {}

-- possible values are 'arrow' | 'rounded' | 'blank'
local active_sep = 'blank'

-- change them if you want to different separator
M.separators = {
  arrow = { '', '' },
  rounded = { '', '' },
  blank = { '', '' },
}

-- highlight groups
M.colors = {
  active             = '%#StatusLine#',
  inactive           = '%#StatuslineNC#',
  mode               = '%#Mode#',
  mode_alt           = '%#ModeAlt#',
  git                = '%#Git#',
  git_alt            = '%#GitAlt#',
  filetype           = '%#Filetype#',
  filetype_alt       = '%#FiletypeAlt#',
  line_col           = '%#LineCol#',
  line_col_alt       = '%#LineColAlt#',
  lsp_diagnostic     = '%#LspDiagnostic#',
  lsp_diagnostic_alt = '%#LspDiagnosticAlt#',
  current_dir        = '%#CurrentDir#',
  current_dir_alt    = '%#CurrentDirAlt#',
}

M.trunc_width = setmetatable({
  mode       = 80,
  git_status = 90,
  filename   = 140,
  line_col   = 60,
}, {
  __index = function()
      return 80
  end
})

M.is_truncated = function(_, width)
  local current_width = vim.api.nvim_win_get_width(0)
  return current_width < width
end

M.modes = setmetatable({
  ['n']  = {'Normal', 'N'};
  ['no'] = {'N·Pending', 'N·P'} ;
  ['v']  = {'Visual', 'V' };
  ['V']  = {'V·Line', 'V·L' };
  [''] = {'V·Block', 'V·B'}; -- this is not ^V, but it's , they're different
  ['s']  = {'Select', 'S'};
  ['S']  = {'S·Line', 'S·L'};
  [''] = {'S·Block', 'S·B'}; -- same with this one, it's not ^S but it's 
  ['i']  = {'Insert', 'I'};
  ['ic'] = {'Insert', 'I'};
  ['R']  = {'Replace', 'R'};
  ['Rv'] = {'V·Replace', 'V·R'};
  ['c']  = {'Command', 'C'};
  ['cv'] = {'Vim·Ex ', 'V·E'};
  ['ce'] = {'Ex ', 'E'};
  ['r']  = {'Prompt ', 'P'};
  ['rm'] = {'More ', 'M'};
  ['r?'] = {'Confirm ', 'C'};
  ['!']  = {'Shell ', 'S'};
  ['t']  = {'Terminal ', 'T'};
}, {
  __index = function()
      return {'Unknown', 'U'} -- handle edge cases
  end
})

M.get_current_mode = function(self)
  local current_mode = vim.api.nvim_get_mode().mode

  if self:is_truncated(self.trunc_width.mode) then
    return string.format(' %s ', self.modes[current_mode][2]):upper()
  end
  return string.format(' %s ', self.modes[current_mode][1]):upper()
end

M.get_git_status = function(self)
  local head = vim.fn['fugitive#Head']()
  -- too verbose
  -- local head = vim.fn['fugitive#statusline']()

  if head == '' then
    return ''
  else
    return string.format(
      ' %s ',
      head
    )
  end
end

M.get_filename = function(self)
  if self:is_truncated(self.trunc_width.filename) then return " %<%f " end
  -- return " %<%F "
  return vim.fn.expand("%")
end

M.get_filetype = function()
  local file_name, file_ext = vim.fn.expand("%:t"), vim.fn.expand("%:e")
  local icon = require'nvim-web-devicons'.get_icon(file_name, file_ext, { default = true })
  local filetype = vim.bo.filetype

  if filetype == '' then return '' end
  return string.format(' %s %s ', icon, filetype):lower()
end

M.get_line_col = function(self)
  if self:is_truncated(self.trunc_width.line_col) then return ' %l:%c ' end
  return ' Ln %l, Col %c '
end

M.get_current_dir = function(self) 
  return string.format(' %s', vim.fn['substitute'](vim.fn['getcwd'](), '^.*/', '', ''))
end

--[[
 NOTE from original author: I don't use this since the statusline already has
 so much stuff going on. Feel free to use it!
 credit: https://github.com/nvim-lua/lsp-status.nvim

 I now use `tabline` to display these errors, go to `_bufferline.lua` if you
 want to check that out
-]]
M.get_lsp_diagnostic = function(self)
  local result = {}
  local levels = {
    errors = vim.diagnostic.severity.ERROR,
    warnings = vim.diagnostic.severity.WARN,
    info = vim.diagnostic.severity.INFO,
    hints = vim.diagnostic.severity.HINT
  }

  for k, level in pairs(levels) do
    result[k] = vim.diagnostic.count(0, { severity = level })[level]
  end

  if self:is_truncated(120) then
    return ''
  else
    return string.format(
      -- "|  %s  %s  %s  %s ",
      -- numbers with pipes somehow seem more clear to me
      "%s|%s|%s|%s",
      result['errors'] or 0, result['warnings'] or 0,
      result['info'] or 0, result['hints'] or 0
    )
  end
end

-- FIXME: doesn't work
M.gitsigns = function(self)
  return ''
--   if self:is_truncated(120) then
--     return vim.get("b:gitsigns_status")
--   else
--     return vim.get("b:gitsigns_status")
--   end
end

M.set_active = function(self)
  local colors = self.colors

  local mode = colors.mode .. self:get_current_mode()
  local mode_alt = colors.mode_alt .. self.separators[active_sep][1]
  local git = colors.git .. self:get_git_status()
  local git_alt = colors.git_alt .. self.separators[active_sep][1]
  local current_dir = colors.current_dir .. self:get_current_dir()
  local current_dir_alt = colors.current_dir_alt .. self.separators[active_sep][1]
  local filename = colors.inactive .. self:get_filename()
  local lsp_diagnostic_alt = colors.lsp_diagnostic_alt .. self.separators[active_sep][2]
  local lsp_diagnostic = colors.lsp_diagnostic .. self:get_lsp_diagnostic()
  local filetype_alt = colors.filetype_alt .. self.separators[active_sep][2]
  local filetype = colors.filetype .. self:get_filetype()
  local line_col = colors.line_col .. self:get_line_col()
  local line_col_alt = colors.line_col_alt .. self.separators[active_sep][2]
  local gitsigns = colors.git .. self:gitsigns()
  local gitsigns_alt = colors.git .. self:gitsigns()

  return table.concat({
    colors.active, mode, mode_alt, git, git_alt, gitsigns, gitsigns_alt, current_dir,
    "%=",
    -- TODO: improve diagnostics, current state is useless
    filetype_alt, filetype, lsp_diagnostic_alt, lsp_diagnostic, line_col_alt, line_col
  })
end

M.set_inactive = function(self)
  return self.colors.inactive .. '%= %F %='
end

M.set_explorer = function(self)
  local title = self.colors.mode .. '   '
  local title_alt = self.colors.mode_alt .. self.separators[active_sep][2]

  return table.concat({ self.colors.active, title, title_alt })
end

Statusline = setmetatable(M, {
  __call = function(statusline, mode)
    if mode == "active" then return statusline:set_active() end
    if mode == "inactive" then return statusline:set_inactive() end
  end
})

-- TODO: comment from zignar.net: replace this once we can define autocmd using lua
-- set statusline: activate when interacting with window/buffer, deactivating when switching
vim.api.nvim_exec([[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline('active')
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline('inactive')
  augroup END
]], false)

