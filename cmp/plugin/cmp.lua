if vim.g.loaded_cmp then
	return
end
vim.g.loaded_cmp = true

if not vim.api.nvim_create_autocmd then
	return print('[nvim-cmp] Your nvim does not has `nvim_create_autocmd` function. Please update to latest nvim.')
end

local api = require('cmp.utils.api')
local types = require('cmp.types')
local highlight = require('cmp.utils.highlight')
local autocmd = require('cmp.utils.autocmd')

vim.api.nvim_set_hl(0, 'CmpItemAbbr', { link = 'CmpItemAbbrDefault', default = true })
vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { link = 'CmpItemAbbrDeprecatedDefault', default = true })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { link = 'CmpItemAbbrMatchDefault', default = true })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link = 'CmpItemAbbrMatchFuzzyDefault', default = true })
vim.api.nvim_set_hl(0, 'CmpItemKind', { link = 'CmpItemKindDefault', default = true })
vim.api.nvim_set_hl(0, 'CmpItemMenu', { link = 'CmpItemMenuDefault', default = true })
for kind in pairs(types.lsp.CompletionItemKind) do
	if type(kind) == 'string' then
		local name = ('CmpItemKind%s'):format(kind)
		vim.api.nvim_set_hl(0, name, { link = ('%sDefault'):format(name), default = true })
	end
end

autocmd.subscribe('ColorScheme', function()
	highlight.inherit('CmpItemAbbrDefault', 'Pmenu', { bg = 'NONE', default = false })
	highlight.inherit('CmpItemAbbrDeprecatedDefault', 'Comment', { bg = 'NONE', default = false })
	highlight.inherit('CmpItemAbbrMatchDefault', 'Pmenu', { bg = 'NONE', default = false })
	highlight.inherit('CmpItemAbbrMatchFuzzyDefault', 'Pmenu', { bg = 'NONE', default = false })
	highlight.inherit('CmpItemKindDefault', 'Special', { bg = 'NONE', default = false })
	highlight.inherit('CmpItemMenuDefault', 'Pmenu', { bg = 'NONE', default = false })
	for name in pairs(types.lsp.CompletionItemKind) do
		if type(name) == 'string' then
			vim.api.nvim_set_hl(0, ('CmpItemKind%sDefault'):format(name), { link = 'CmpItemKind', default = false })
		end
	end
end)
autocmd.emit('ColorScheme')

if vim.on_key then
	vim.on_key(function(keys)
		if keys == vim.api.nvim_replace_termcodes('<C-c>', true, true, true) then
			vim.schedule(function()
				if not api.is_suitable_mode() then
					autocmd.emit('InsertLeave')
				end
			end)
		end
	end, vim.api.nvim_create_namespace('cmp.plugin'))
end

vim.api.nvim_create_user_command('CmpStatus', function()
	require('cmp').status()
end, { desc = 'Check status of cmp sources' })

-- vim.cmd([[doautocmd <nomodeline> User CmpReady]])

local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup {
	mapping = cmp.mapping.preset.insert {
		['<C-d>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(1) then
				luasnip.jump(1)
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<C-s>'] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	},
	sources = cmp.config.sources {
		{ name = 'nvim_lsp', keyword_length = 1 },
		{ name = 'luasnip',  keyword_length = 2 },
		{ name = 'buffer',   keyword_length = 2 },
		{ name = 'path',     keyword_length = 2 },
	}
}

cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline {},
	sources = cmp.config.sources({ { name = 'cmdline' } })
})
