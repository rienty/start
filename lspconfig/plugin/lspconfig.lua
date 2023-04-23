local api, lsp = vim.api, vim.lsp

if vim.g.lspconfig ~= nil then
	return
end
vim.g.lspconfig = 1

local version_info = vim.version()
if vim.fn.has 'nvim-0.7' ~= 1 then
	local warning_str = string.format(
		'[lspconfig] requires neovim 0.7 or later. Detected neovim version: 0.%s.%s',
		version_info.minor,
		version_info.patch
	)
	vim.notify_once(warning_str)
	return
end

local completion_sort = function(items)
	table.sort(items)
	return items
end

local lsp_complete_configured_servers = function(arg)
	return completion_sort(vim.tbl_filter(function(s)
		return s:sub(1, #arg) == arg
	end, require('lspconfig.util').available_servers()))
end

local lsp_get_active_client_ids = function(arg)
	local clients = vim.tbl_map(function(client)
		return ('%d (%s)'):format(client.id, client.name)
	end, require('lspconfig.util').get_managed_clients())

	return completion_sort(vim.tbl_filter(function(s)
		return s:sub(1, #arg) == arg
	end, clients))
end

local get_clients_from_cmd_args = function(arg)
	local result = {}
	for id in (arg or ''):gmatch '(%d+)' do
		result[id] = lsp.get_client_by_id(tonumber(id))
	end
	if vim.tbl_isempty(result) then
		return require('lspconfig.util').get_managed_clients()
	end
	return vim.tbl_values(result)
end

for group, hi in pairs {
	LspInfoBorder = { link = 'Label', default = true },
	LspInfoList = { link = 'Function', default = true },
	LspInfoTip = { link = 'Comment', default = true },
	LspInfoTitle = { link = 'Title', default = true },
	LspInfoFiletype = { link = 'Type', default = true },
} do
	api.nvim_set_hl(0, group, hi)
end

-- Called from plugin/lspconfig.vim because it requires knowing that the last
-- script in scriptnames to be executed is lspconfig.
api.nvim_create_user_command('LspInfo', function() require 'lspconfig.ui.lspinfo' () end,
	{ desc = 'Displays attached, active, and configured language servers', }
)

api.nvim_create_user_command('LspStart',
	function(info)
		local server_name = string.len(info.args) > 0 and info.args or nil
		if server_name then
			local config = require('lspconfig.configs')[server_name]
			if config then
				config.launch()
				return
			end
		end

		local matching_configs = require('lspconfig.util').get_config_by_ft(vim.bo.filetype)
		for _, config in ipairs(matching_configs) do
			config.launch()
		end
	end,
	{
		desc = 'Manually launches a language server',
		nargs = '?',
		complete = lsp_complete_configured_servers,
	}
)

api.nvim_create_user_command('LspRestart', function(info)
	local detach_clients = {}
	for _, client in ipairs(get_clients_from_cmd_args(info.args)) do
		client.stop()
		detach_clients[client.name] = client
	end
	local timer = vim.loop.new_timer()
	timer:start(
		500,
		100,
		vim.schedule_wrap(function()
			for client_name, client in pairs(detach_clients) do
				if client.is_stopped() then
					require('lspconfig.configs')[client_name].launch()
					detach_clients[client_name] = nil
				end
			end

			if next(detach_clients) == nil and not timer:is_closing() then
				timer:close()
			end
		end)
	)
end, {
	desc = 'Manually restart the given language client(s)',
	nargs = '?',
	complete = lsp_get_active_client_ids,
})

api.nvim_create_user_command('LspStop', function(info)
	local current_buf = vim.api.nvim_get_current_buf()
	local server_name, force
	local arguments = vim.split(info.args, '%s')
	for _, v in pairs(arguments) do
		if v == '++force' then
			force = true
		end
		if v:find '%(' then
			server_name = v
		end
	end

	if not server_name then
		local servers_on_buffer = lsp.get_active_clients { bufnr = current_buf }
		for _, client in ipairs(servers_on_buffer) do
			if client.attached_buffers[current_buf] then
				client.stop(force)
			end
		end
	else
		for _, client in ipairs(get_clients_from_cmd_args(server_name)) do
			client.stop(force)
		end
	end
end, {
	desc = 'Manually stops the given language client(s)',
	nargs = '?',
	complete = lsp_get_active_client_ids,
})

api.nvim_create_user_command('LspLog', function()
	vim.cmd(string.format('tabnew %s', lsp.get_log_path()))
end, {
	desc = 'Opens the Nvim LSP client log.',
})


vim.diagnostic.config { virtual_text = false }

require('lspconfig').texlab.setup {}
require('lspconfig').lua_ls.setup {}
require('lspconfig').ltex.setup {}
require('lspconfig').vimls.setup {}
require('lspconfig').bashls.setup {}

-- keymap
-- Diagnostic keymap
vim.keymap.set('n', 'me', vim.diagnostic.open_float)
vim.keymap.set('n', 'mp', vim.diagnostic.goto_prev)
vim.keymap.set('n', 'mo', vim.diagnostic.goto_next)
vim.keymap.set('n', 'mq', vim.diagnostic.setloclist)

-- Lsp keymap
vim.keymap.set('n', 'mr', vim.lsp.buf.rename)
vim.keymap.set('n', 'mn', function() vim.lsp.buf.format { async = true } end)
vim.keymap.set('n', 'ma', vim.lsp.buf.add_workspace_folder)
vim.keymap.set('n', 'mw', vim.lsp.buf.remove_workspace_folder)
vim.keymap.set('n', 'ml', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
vim.keymap.set('n', 'mg', vim.lsp.buf.declaration)
vim.keymap.set('n', 'md', vim.lsp.buf.definition)
vim.keymap.set('n', 'mf', vim.lsp.buf.references)
vim.keymap.set('n', 'mh', vim.lsp.buf.hover)
vim.keymap.set('n', 'mu', vim.lsp.buf.implementation)
vim.keymap.set('n', 'mk', vim.lsp.buf.signature_help)
vim.keymap.set('n', 'mt', vim.lsp.buf.type_definition)
vim.keymap.set('n', 'mc', vim.lsp.buf.code_action)

-- Tex keymap
function TeXkeybinds()
	vim.keymap.set("i", ",c", "<esc>:w<CR>:TexlabBuild<CR>")
	vim.keymap.set("i", ",s", "<esc>:w<CR>:TexlabForward<CR>")
	vim.keymap.set("i", ",v", "<esc>:e ~/.local/share/nvim/site/pack/plugins/start/lausnip/snippets/latex.json<CR>")
	vim.keymap.set("i", ",g", "<esc>/<++><CR>:nohlsearch<CR>c4l")
	vim.keymap.set("i", ",r", "$ <--> $<++><esc>?<--><CR>N:nohlsearch<CR>c4l")
	vim.keymap.set("i", ",t", "$$ <--> $$<++><esc>?<--><CR>N:nohlsearch<CR>c4l")
	vim.keymap.set("i", ",d", "_{<-->}<++><esc>?<--><CR>N:nohlsearch<CR>di{i")
	vim.keymap.set("i", ",e", "^{<-->}<++><esc>?<--><CR>N:nohlsearch<CR>di{i")
	vim.keymap.set("i", ".b", "\\beta")
	vim.keymap.set("i", ".a", "\\alpha")
	vim.keymap.set("i", ".g", "\\gamma")
	vim.keymap.set("i", ".d", "\\delta")
	vim.keymap.set("i", ".e", "\\epsilon")
	vim.keymap.set("i", ".t", "\\eta")
	vim.keymap.set("i", ".r", "\\rho")
	vim.keymap.set("i", ".G", "\\Gamma")
	vim.keymap.set("i", ".h", "\\theta")
	vim.keymap.set("i", ".m", "\\sigma")
	vim.keymap.set("i", ".f", "\\phi")
	vim.keymap.set("i", ".p", "\\pi")
	vim.keymap.set("i", ".u", "\\mu")
	vim.keymap.set("i", ".D", "\\Delta")
	vim.keymap.set("i", ".n", "\\nabla")
	vim.keymap.set("i", ".i", "\\in")
	vim.keymap.set("i", ".I", "\\infty")
	vim.keymap.set("i", ".R", "\\Ric")
	vim.keymap.set("i", ".S", "\\sec")
	vim.keymap.set("i", ".v", "\\vol")
end
vim.api.nvim_create_autocmd('BufWinEnter, BufEnter', { pattern = { "*.tex" }, callback = function() TeXkeybinds() end })

