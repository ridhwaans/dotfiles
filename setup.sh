#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	# Write permissions for Homebrew 
	sudo chown -R $(whoami) /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig
	chmod u+w /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig

	# Check for Homebrew and install it if missing
	if test ! $(which brew)
	then
		echo "Installing Homebrew..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
		imagemagick
		jenkins
		jmeter
		mysql
		postgresql
		screen
		screenfetch
		tig
		tree
		v8-315
		wget
	)
	brew install "${apps[@]}"
	sudo easy_install pip

	# Install Caskroom
	brew tap homebrew/cask
	brew tap homebrew/cask-versions

	apps=(
		beekeeper-studio
		cyberduck
		datagrip
		docker
		discord
		dropbox
		figma
		flux
		google-chrome
		iterm2-nightly
		mounty
		notion
		postman
		zoom
		slack
		spotify
		steam
		visual-studio-code
	)
	brew install --cask "${apps[@]}"

	# Remove outdated versions from the cellar
	brew cleanup

	# Set defaults
	defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
	defaults write com.apple.systemuiserver menuExtras -array 
	"/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
	"/System/Library/CoreServices/Menu Extras/Clock.menu" 
	"/System/Library/CoreServices/Menu Extras/Displays.menu"
	"/System/Library/CoreServices/Menu Extras/Volume.menu"
	killall SystemUIServer

	# Set Dock items
	OLDIFS=$IFS
	IFS=''

	apps=(
		'Google Chrome'
		'Visual Studio Code'
		iTerm
		Postman
		Spotify
		Slack
		Zoom
		Cyberduck
		'System Preferences'
		DataGrip
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
		screen
		screenfetch
		tig
		tree
		wget
		zip
		zsh
	)
	apt install "${apps[@]}"

	curl https://cli-assets.heroku.com/install.sh | sh
	curl -L https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip -o aws-sam-cli-linux-x86_64.zip
	unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
	sudo ./sam-installation/install
	rm -rf sam-installation

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
if ! [[ "$file" =~ ^(.git|media|README.md|setup.sh|remote-setup.sh|setup-corp-ad-ctc.sh|setup-wishabi.sh)$ ]]; then 
	ln -sf $PWD/$file $HOME/
fi
done

# Run `chsh -s $(which zsh)` to set ZSH as the default shell
# In Mac, add `zsh` to Full Disk Access in Security & Privacy (cmd+shift+G in Finder)
# Run `:PluginInstall` in Vim
# Install language versions, language package managers separately under version managers
