vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local bufmap = function(mode, rhs, lhs)
      vim.keymap.set(mode, rhs, lhs, { buffer = event.buf })
    end

    -- These keymaps are the defaults in Neovim v0.11
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    bufmap('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
    -- bufmap('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    -- bufmap({ 'i', 's' }, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- These are custom keymaps
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    bufmap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    bufmap({ 'n', 'x' }, '<leader>F', '<cmd>lua vim.lsp.buf.format({async = true})<CR>')
    -- TODO: can also call :GMove from fugitive here?
    bufmap('n', '<leader>ra', '<cmd>lua vim.lsp.buf.rename()<CR>')
    bufmap('n', '<leader>q', '<cmd>lua vim.diagnostic.open_float()<CR>')

    -- -- TODO: configure lua to acknowledge neovim globals and correct lua version
  end,
})

vim.lsp.inlay_hint.enable(true)

vim.diagnostic.config {
  -- plain text next to the code
  virtual_text = false,
  -- show issues when cursor on the line
  -- virtual_lines = { current_line = false },
  virtual_lines = false,
}

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✘',
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.HINT] = '⚑',
      [vim.diagnostic.severity.INFO] = '»',
    },
  },
})

-- Set up nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<C-y>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'buffer' },
  })
})

-- TODO: check docs: way more can be done

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- vim.lsp.config('<YOUR_LSP_SERVER>', {
--   capabilities = capabilities
-- })
-- vim.lsp.enable('<YOUR_LSP_SERVER>')
