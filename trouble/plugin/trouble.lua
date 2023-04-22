vim.api.nvim_create_autocmd('DiagnosticChanged',
	{ callback = function() require 'trouble'.refresh({ auto = true, provider = "diagnostics" }) end })

vim.api.nvim_create_user_command("TroubleToggle", function(opts)
		require 'trouble'.toggle(unpack(opts.fargs))
	end,
	{
		nargs = "*",
		complete = function()
			return vim.tbl_keys(require("trouble.providers").providers)
		end
	})

vim.keymap.set("n", "<LEADER>r", "<cmd>TroubleToggle lsp_references<cr>")
vim.keymap.set("n", "<LEADER>h", "<cmd>TroubleToggle document_diagnostics<cr>")
