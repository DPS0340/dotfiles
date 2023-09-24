with (import <nixpkgs> {});
mkShell {
  shellHook = ''
	exec zsh
  	source zprofile
  	source zshrc
  '';
	buildInputs = [
		coreutils-full
		terraform
		openssh
		ansible_2_13
		zsh
		zplug
		neovim
		tldr
		gh
		bat
		eza
		neofetch
		curl
		wget
		thefuck
		nodejs
		gcc
		fzf
		gnupg
		go
		kubectl
		terraform
		nerdfonts
		jetbrains-mono
		wezterm
		lazygit
		k9s
		git
		rclone
		unixtools.nettools
		awscli2
		yq
		jq
		tmux
		imgcat
	];
}

