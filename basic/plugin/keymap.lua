--Remap space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal
vim.keymap.set("n", "<LEADER>q", ":q<CR>")
vim.keymap.set("n", "<LEADER>w", ":w<CR>")
vim.keymap.set("n", "<LEADER>z", ":only<CR>")
vim.keymap.set("n", "<LEADER>n", ":nohlsearch<CR>")
vim.keymap.set("n", "<LEADER>f", ":e ")
vim.keymap.set("n", "<LEADER>b", ":buffer ")
vim.keymap.set("i", "<Tab>", "<ESC>")
vim.keymap.set("i", "<Esc>", "<Tab>")
vim.keymap.set("v", "<Tab>", "<ESC>")
vim.keymap.set("v", "<ESC>", "<Tab>")
-- Insert --
vim.keymap.set("i", ",a", "<ESC>A")
vim.keymap.set("i", ",q", "<ESC>0i")
vim.keymap.set("i", ",f", "<ESC>la")
vim.keymap.set("i", ",z", "<ESC>zza")

