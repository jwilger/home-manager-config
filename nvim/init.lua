local builtin = require('telescope.builtin')
local map = vim.keymap.set
local set = vim.opt
local defaults = {noremap = true, silent = true}
local wk = require('which-key')

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.cmd.colorscheme "catppuccin-macchiato"

set.shellcmdflag = '-ic'
set.scrolloff = 20

set.foldmethod = 'expr'
set.foldexpr = 'nvim_treesitter#fold_expr()'

map("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

map("i", "jk", "<esc>l", defaults)

map("n", "<C-h>", "<C-w>h", defaults)
map("n", "<C-j>", "<C-w>j", defaults)
map("n", "<C-k>", "<C-w>k", defaults)
map("n", "<C-l>", "<C-w>l", defaults)

map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = 'Toggle Nvim Tree' })

wk.add({
	{ "<leader>f", group = "file" },
	{ "<leader>ff", builtin.find_files, desc = "Find File" },
	{ "<leader>fg", builtin.live_grep, desc = "Find Word(s) in File" },

	{ "<leader>b", group = "buffers" },
	{ "<leader>bb", builtin.buffers, desc = "List Buffers" },
	{ "<leader>bn", "<cmd>bnext<cr>", desc = "Next Buffer" },
	{ "<leader>bp", "<cmd>bpref<cr>", desc = "Previous Buffer" }
})
