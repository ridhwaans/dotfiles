#!/usr/bin/env bash

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
	apache-spark
	dockutil
	figlet
	git
	imagemagick
	jmeter
	koekeishiya/formulae/khd
	koekeishiya/formulae/kwm
	mysql
	npm
	phantomjs
	postgresql
	python
	python3
	ruby
	s3cmd
	scala
	screen
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

# flux
apps=(
	cyberduck
	dropbox
	google-chrome
	iterm2-nightly
	postico
	postman
	pycharm
	rubymine
	sequel-pro
	slack
	spotify
	sublime-text
)
brew cask install "${apps[@]}"

# Remove outdated versions from the cellar
brew cleanup

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

# Symlink dotfiles
git pull origin master;

for file in $(ls -A); do
if [ "$file" != ".git" ] && \
   [ "$file" != "setup.sh" ] && \
   [ "$file" != "remote-setup.sh" ] && \
   [ "$file" != "README.md" ] && \
   [ "$file" != "images" ]; then
    ln -sf $PWD/$file $HOME/
fi
done

# Mac
# Install xcode and command line tools

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

# # Get Flipp projects
# projects=(
# 	pushback
# 	editorials
# 	module-templates
# 	fadmin
# 	HealthCheck-2.0
# 	flyer_availability_service
# 	auction_house
# 	marketing_automation
# 	groda
# 	editorials_automation
# 	backflipp
# 	biggerdata
# 	merchants
# 	qa_data
# 	qa
# 	qa_process
# )

# for project in "${projects[@]}"
# do
# 	git clone git@github.com:wishabi/$project.git $HOME/Source/$project
# done

# # Setup ruby and python environments
# echo "Setup ruby and python environments"
# CC=/usr/bin/gcc rbenv install 1.9.3-p194
# rbenv install 2.1.1
# rbenv rehash
# rbenv global 1.9.3-p194
# gem install bundler
# cd $HOME/Source/editorials
# rbenv local 1.9.3-p194
# rbenv gemset init
# bundle install

# pyenv install 2.7.6
# pyenv install 3.6.0
# pyenv rehash
# pyenv global 2.7.6
# pyenv virtualenv 2.7.6 hc