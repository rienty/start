--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal
vim.keymap.set("n", "<LEADER>q", ":q<CR>")
vim.keymap.set("n", "<LEADER>w", ":w<CR>")
vim.keymap.set("n", "<LEADER>z", ":only<CR>")
vim.keymap.set("n", "<LEADER>n", ":nohlsearch<CR>")
vim.keymap.set("n", "<LEADER>f", ":e")
vim.keymap.set("n", "<LEADER>b", ":buffer")
vim.keymap.set("i", "<Tab>", "<ESC>")
vim.keymap.set("i", "<Esc>", "<Tab>")
vim.keymap.set("v", "<Tab>", "<ESC>")
vim.keymap.set("v", "<ESC>", "<Tab>")
-- Insert --
vim.keymap.set("i", ",a", "<ESC>A")
vim.keymap.set("i", ",q", "<ESC>0i")
vim.keymap.set("i", ",f", "<ESC>la")
vim.keymap.set("i", ",z", "<ESC>zza")

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

