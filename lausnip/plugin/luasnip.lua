require('luasnip.config')._setup {}

vim.api.nvim_create_autocmd('BufWinEnter', {
	callback =
		function()
			require('luasnip.loaders.from_vscode')._load_lazy_loaded(tonumber(vim.fn.expand("<abuf>")))
		end
})

require('luasnip.loaders.from_vscode').lazy_load {}
