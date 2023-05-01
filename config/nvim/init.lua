local vimrc = vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd.source(vimrc)

if vim.g.vscode == nil then 
	-- from https://github.com/nvim-tree/nvim-tree.lua
	-- disable netrw at the very start of your init.lua (strongly advised)
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1

	-- set termguicolors to enable highlight groups
	vim.opt.termguicolors = true

	-- empty setup using defaults
	require("nvim-tree").setup()
end
