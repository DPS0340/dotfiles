if exists('g:vscode')
	set runtimepath+=~/.vim,~/.vim/after
	set packpath+=~/.vim

	set tabstop=4
	set shiftwidth=4
	set noexpandtab

	"  map <TAB> >><CR>
	"  map <S-TAB> <<<CR>
	vmap ' gc
	nmap ' gc<CR>
	" Clipboard for WSL
	map q <Nop>

	set clipboard+=unnamedplus

	call plug#begin()

	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-commentary'
	Plug 'junegunn/vim-slash'

	call plug#end()

	" Easy yank / paste using clipboard

	:command Cyf :normal ggVG"+y<CR>
	:command Cpf :normal "+P<CR>

	:command Boilerplate :normal :r ~/programming/boj/boilerplate.cpp<CR>ggJ<CR>
else
	set runtimepath+=~/.vim,~/.vim/after
	set packpath+=~/.vim
	source ~/.vimrc
endif
