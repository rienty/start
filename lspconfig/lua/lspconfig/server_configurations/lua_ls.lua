local util = require 'lspconfig.util'

local root_files = {
	'.luarc.json',
	'.luarc.jsonc',
	'.luacheckrc',
	'.stylua.toml',
	'stylua.toml',
	'selene.toml',
	'selene.yml',
}

local bin_name = 'lua-language-server'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
	cmd = { 'cmd.exe', '/C', bin_name }
end

return {
	default_config = {
		cmd = cmd,
		filetypes = { 'lua' },
		root_dir = function(fname)
			local root = util.root_pattern(unpack(root_files))(fname)
			if root and root ~= vim.env.HOME then
				return root
			end
			root = util.root_pattern 'lua/' (fname)
			if root then
				return root .. '/lua/'
			end
			return util.find_git_ancestor(fname)
		end,
		single_file_support = true,
		log_level = vim.lsp.protocol.MessageType.Warning,
		settings = {
			Lua = {
				runtime = { version = 'LuaJIT' },
				diagnostics = { globals = { 'vim' }, },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	},
	docs = {
		description = [[ https://github.com/luals/lua-language-server. ]],
		default_config = {
			root_dir = [[root_pattern(".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git")]],
		},
	},
}
