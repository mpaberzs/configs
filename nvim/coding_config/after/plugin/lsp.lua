local lsp = require('lsp-zero')
-- require('lspconfig').intelephense.setup({})
lsp.preset("recommended")
lsp.on_attach(function(client, bufnr) 
		local opts = {buffer=bufnr, remap=false}
		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
		vim.keymap.set("n", "<leader>ra", function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set("n", "<leader>D", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
end)

require('mason').setup({})
require('mason-lspconfig').setup({
		-- Replace the language servers listed here
		-- with the ones you want to install
		ensure_installed = {
				"tsserver",
				"eslint",
				"rust_analyzer"
		},
		handlers = {
				function(server_name)
						require('lspconfig')[server_name].setup({})
				end,
		},
})

local cmp = require("cmp")
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		['<C-y>'] = cmp.mapping.confirm({select = true})
		-- ['<C-Space>'] = cmp.mapping.complete()
})
lsp.setup()
