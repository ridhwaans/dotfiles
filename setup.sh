#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
	# Ask for the administrator password upfront
	sudo -v

	# Check for Homebrew and install it if missing
	if test ! $(which brew)
	then
		echo "Installing Homebrew..."
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# Make sure we’re using the latest Homebrew
	brew update
	# Upgrade any already-installed formulae
	brew tap homebrew/versions
	brew tap heroku/brew
	brew upgrade --all

	apps=(
		awscli
		dockutil
		figlet
		git
		graphviz
		heroku
		imagemagick
		jenkins
		jmeter
		koekeishiya/formulae/khd
		koekeishiya/formulae/kwm
		mysql
		node
		phantomjs
		postgresql
		screen
		screenfetch
		tig
		tree
		v8-315
		vegeta
		wget
	)
	brew install "${apps[@]}"
	sudo easy_install pip

	# Install Caskroom
	brew tap caskroom/cask
	brew tap caskroom/versions

	apps=(
		cyberduck
		docker
		discord
		dropbox
		flux
		google-chrome
		hipchat
		iterm2-nightly
		postico
		postman
		pycharm
		rubymine
		sequel-pro
		skype
		slack
		spotify
		steam
		sublime-text
	)
	brew cask install "${apps[@]}"

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
		'Sublime Text'
		iTerm
		Postman
		RubyMine
		PyCharm
		Spotify
		Slack
		Skype
		Cyberduck
		'System Preferences'
		'Sequel Pro'
		Postico
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

elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	# Ask for the administrator password upfront
	sudo -v

	# Make sure we’re using the latest repositories
	apt update

	apps=(
		awscli
		figlet
		git
		graphviz
		mysql-server
		nodejs
		postgresql postgresql-contrib
		screen
		screenfetch
		tig
		tree
		wget
		zsh
	)
	apt install "${apps[@]}"
	curl https://cli-assets.heroku.com/install.sh | sh
fi

# Go to the base directory
cd "$(dirname "${BASH_SOURCE}")";
git init
git remote add origin git@github.com:ridhwaans/dotfiles.git

# Install submodules
git submodule add -f git@github.com:VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
git submodule add -f git@github.com:zsh-users/antigen.git .zsh/bundle
git submodule add -f git@github.com:pyenv/pyenv.git .pyenv
cd .pyenv
git submodule add -f git@github.com:pyenv/pyenv-virtualenv.git plugins/pyenv-virtualenv
cd ..
git submodule add -f git@github.com:rbenv/rbenv.git .rbenv
cd .rbenv
git submodule add -f git@github.com:rbenv/ruby-build.git plugins/ruby-build
git submodule add -f git@github.com:jf/rbenv-gemset.git plugins/rbenv-gemset
cd ..
git submodule add -f git@github.com:gcuisinier/jenv.git .jenv

# Symlink dotfiles
git pull origin master;

for file in $(ls -A); do
if ! [[ "$file" =~ ^(.git|media|setup.sh|remote-setup.sh|setup-corp-ad-ctc.sh|setup-wishabi.sh|README.md)$ ]]; then 
	ln -sf $PWD/$file $HOME/
fi
done

# Add `bash -c zsh` to the top of ~/.profile
# Add zsh to Full Disk Access in Security & Privacy (cmd+shift+G in Finder)
# Run :PluginInstall in Vim
# Install Node, PIP, Maven, Gradle separately under virtual-env (npm is installed with node)
