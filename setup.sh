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
	brew upgrade --all

	apps=(
		ant
		dockutil
		figlet
		git
		gradle
		graphviz
		groovy
        heroku
		imagemagick
		jenkins
		jmeter
		koekeishiya/formulae/khd
		koekeishiya/formulae/kwm
		maven
		mysql
		node
		phantomjs
		postgresql
		python
		python3
		ruby
		s3cmd
		scala
		screen
        screenfetch
		sphinx
		stow
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

	# Set screencapture location
	defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
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
		HipChat
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
		ant
		figlet
		git
		gradle
		groovy
		maven
		nodejs
		npm
		python
		python3
		graphviz
		ruby
		s3cmd
		scala
		screen
		screenfetch
		stow
		tig
		tree
		wget
		zsh
	)
	apt install "${apps[@]}"
	apt install python-pip python-dev build-essential
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
if [ "$file" != ".git" ] && \
   [ "$file" != "setup.sh" ] && \
   [ "$file" != "remote-setup.sh" ] && \
   [ "$file" != "setup-corp-ad-ctc.sh" ] && \
   [ "$file" != "setup-wishabi.sh" ] && \
   [ "$file" != "README.md" ] && \
   [ "$file" != "media" ]; then
	ln -sf $PWD/$file $HOME/
fi
done

# Add `bash -c zsh` to the top of ~/.bashrc
# Run :PluginInstall in Vim
