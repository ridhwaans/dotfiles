#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	# Write permissions for Homebrew 
	sudo chown -R $(whoami) /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig
	chmod u+w /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig

	# Install Homebrew if missing
	if test ! $(which brew)
	then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	# Make sure we’re using the latest Homebrew
	brew update

	# Upgrade any already-installed formulae
	brew tap homebrew/core
	brew tap heroku/brew
	brew tap aws/tap
	brew upgrade

	apps=(
		awscli
		aws-sam-cli
		dockutil
		exercism
		git
		go
		heroku
		mysql
		postgresql
		screenfetch
		tig
		tree
	)
	brew install "${apps[@]}"

	# Install Caskroom
	brew tap homebrew/cask
	brew tap homebrew/cask-versions

	apps=(
		beekeeper-studio
		docker
		discord
		dropbox
		figma
		google-chrome
		iterm2-nightly
		mounty
		notion
		postman
		slack
		steam
		visual-studio-code
		zoom
	)
	brew install --cask "${apps[@]}"

	# Remove outdated versions from the cellar
	brew cleanup

	# Set Dock items
	OLDIFS=$IFS
	IFS=''

	apps=(
		'Google Chrome'
		'Visual Studio Code'
		iTerm
		Postman
		Notion
		Slack
		Figma
		zoom.us
		'System Preferences'
	)

	dockutil --no-restart --remove all $HOME
	for app in "${apps[@]}"
	do
		echo "Keeping $app in Dock"
		dockutil --no-restart --add /Applications/$app.app $HOME
	done
	killall Dock

	# restore $IFS
	IFS=$OLDIFS

elif [ "$(uname)" == "Linux" ]; then
	# Make sure we’re using the latest repositories
	apt update

	# Upgrade any already-installed packages
	apt upgrade

	apps=(
		awscli
		git
		golang-go
		mysql-server
		postgresql postgresql-contrib
		screenfetch
		tig
		tree
		zip
		zsh
	)
	apt install "${apps[@]}"

	curl -L https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip -o aws-sam-cli-linux-x86_64.zip
	unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
	sudo ./sam-installation/install
	rm -rf sam-installation
	curl https://cli-assets.heroku.com/install.sh | sh

	# Remove no longer required packages
	sudo apt autoremove
fi

# Go to the base directory
cd "$(dirname "${BASH_SOURCE}")";

git init
git remote add origin git@github.com:ridhwaans/dotfiles.git

# Install submodules
git submodule add -f git@github.com:VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
git submodule add -f git@github.com:zsh-users/antigen.git .zsh/bundle
git submodule add -f git@github.com:nvm-sh/nvm.git .nvm
git submodule add -f git@github.com:pyenv/pyenv.git .pyenv
cd .pyenv
git submodule add -f git@github.com:pyenv/pyenv-virtualenv.git plugins/pyenv-virtualenv
cd ..
git submodule add -f git@github.com:rbenv/rbenv.git .rbenv
cd .rbenv
git submodule add -f git@github.com:rbenv/ruby-build.git plugins/ruby-build
git submodule add -f git@github.com:jf/rbenv-gemset.git plugins/rbenv-gemset
cd ..

export SDKMAN_DIR=$PWD/.sdkman  && curl https://get.sdkman.io | sh
source $SDKMAN_DIR/bin/sdkman-init.sh

# Symlink dotfiles
git pull origin master;

for file in $(ls -A); do
if ! [[ "$file" =~ ^(.git|media|README.md|setup.sh|remote-setup.sh|setup-atlas.sh|setup-wishabi.sh)$ ]]; then 
	ln -sf $PWD/$file $HOME/
fi
done

# Run `chsh -s $(which zsh)` to set ZSH as default, run `echo $SHELL` to verify
# In Mac, add `zsh` to Full Disk Access in Security & Privacy (cmd+shift+G in Finder)
# Run `:PluginInstall` in Vim
# Install language versions, language package managers separately under version managers
