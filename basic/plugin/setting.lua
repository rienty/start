-- Basic
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.termguicolors = true
vim.opt.laststatus = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.spell = true
vim.opt.numberwidth = 1
vim.opt.signcolumn = "no"
vim.opt.showmode = true
vim.opt.showtabline = 0
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 1
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = "a"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.undofile = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.updatetime = 300
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.pumheight = 10
vim.opt.pumblend = 5
vim.opt.winblend = 0
vim.opt.wildoptions = "pum"
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.backup = false
vim.opt.writebackup = false

vim.api.nvim_create_autocmd('BufWinEnter', { callback = function() vim.wo.fillchars = "eob: " end })
vim.api.nvim_create_autocmd('BufWinEnter', { callback = function() vim.api.nvim_feedkeys([[g`"]], 'x', false) end })
vim.api.nvim_create_autocmd('BufWinEnter', { callback = function() vim.opt.cursorline = true end })

vim.g.tex_flavor = "latex"

