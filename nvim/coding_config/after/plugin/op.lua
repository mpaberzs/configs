local op = require('op')

op.setup({
  -- you can change this to a full path if `op`
  -- is not on your $PATH
  op_cli_path = 'op',
  -- Whether to sign in on start.
  signin_on_start = false,
  -- show NerdFont icons in `vim.ui.select()` interfaces,
  -- set to false if you do not use a NerdFont or just
  -- don't want icons
  use_icons = true,
  -- settings for op.nvim sidebar
  sidebar = {
    -- sections to include in the sidebar
    sections = {
      favorites = true,
      secure_notes = true,
    },
    -- sidebar width
    width = 40,
    -- put the sidebar on the right or left side
    side = 'right',
    -- keymappings for the sidebar buffer.
    -- can be a string mapping to a function from
    -- the module `op.sidebar.actions`,
    -- an editor command string, or a function.
    -- if you supply a function, a table with the following
    -- fields will be passed as an argument:
    -- {
    --   title: string,
    --   icon: string,
    --   type: 'header' | 'item'
    --   -- data will be nil if type == 'header'
    --   data: nil | {
    --       uuid: string,
    --       vault_uuid: string,
    --       category: string,
    --       url: string
    --     }
    -- }
    mappings = {
      -- if it's a Secure Note, open in op.nvim's Secure Notes editor;
      -- if it's an item with a URL, open & fill the item in default browser;
      -- otherwise, open in 1Password 8 desktop app
      ['<CR>'] = 'default_open',
      -- open in 1Password 8 desktop app
      ['go'] = 'open_in_desktop_app',
      -- edit in 1Password 8 desktop app
      ['ge'] = 'edit_in_desktop_app',
    },
  },
  -- Custom formatter function for statusline component
  -- statusline_fmt = function(account_name)
  --   if not account_name or #account_name == 0 then
  --     return ' 1Password: No active session'
  --   end
  --
  --   return string.format(' 1Password: %s', account_name)
  -- end,
  -- global_args accepts any arguments
  -- listed under "Global Flags" in
  -- `op --help` output.
  global_args = {
    -- use the item cache
    '--cache',
    -- print output with no color, since we
    -- aren't viewing the output directly anyway
    '--no-color',
  },
  -- Use biometric unlock by default,
  -- set this to false and also see
  -- "Using Token-Based Sessions" section
  -- of README.md if you don't use biometric
  -- unlock for CLI.
  biometric_unlock = false,
  -- settings for Secure Notes editor
  secure_notes = {
    -- prefix for buffer names when
    -- editing 1Password Secure Notes
    buf_name_prefix = '1P:',
  },
  -- configuration for automatic secret detection
  -- it can also be triggered manually with `:OpAnalyzeBuffer`
  secret_detection_diagnostics = {
    -- disable the feature if set to true
    disabled = false,
    -- severity of produced diagnostics
    severity = vim.diagnostic.severity.WARN,
    -- disable on files longer than this
    max_file_lines = 10000,
    -- disable on these filetypes
    disabled_filetypes = {
      'nofile',
      'TelescopePrompt',
      'NvimTree',
      'Trouble',
      '1PasswordSidebar',
    },
  }
})

-- vim.keymap.set("n", "<leader>PL", function() op.op_signin() end, opts)
