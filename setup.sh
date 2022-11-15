#!/usr/bin/env bash

if [ $(uname) == "Darwin" ]; then
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
	brew tap aws/tap
	brew upgrade

	packages=(
		awscli
		aws-sam-cli
		dockutil
		exercism
		git
		go
		mysql
		postgresql
		screenfetch
		tig
		tree
	)
	brew install "${packages[@]}"

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

elif [ $(uname) == "Linux" ]; then	
	echo "Fetching the latest versions of the package list..."
	sudo apt update -y

	echo "Installing updates for each outdated package and dependency..."
	sudo apt upgrade -y

	echo "Configuring timezone..."
	DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC sudo -E apt install -y tzdata
	sudo ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

	packages=(
		awscli
		git
		golang-go
		mysql-server
		postgresql postgresql-contrib
		screenfetch
		tig
		tree
		vim
		zip
		zsh
	)
	echo "Installing packages..."
	sudo apt install -y "${packages[@]}"
	
	curl -L https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip --create-dirs -o $HOME/aws-sam-cli-linux-x86_64.zip && cd $(dirname $_)
	unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
	sudo ./sam-installation/install
	rm -rf sam-installation
	rm -rf aws-sam-cli-linux-x86_64.zip

	curl -L https://github.com/exercism/cli/releases/download/v3.1.0/exercism-3.1.0-linux-x86_64.tar.gz -o exercism-3.1.0-linux-x86_64.tar.gz
	tar -xf exercism-3.1.0-linux-x86_64.tar.gz
	mkdir -p $HOME/bin && mv exercism $_
	~/bin/exercism
	rm -rf exercism-3.1.0-linux-x86_64.tar.gz

	echo "Removing packages that are no longer required..."
	sudo apt autoremove
fi

echo "Setting up dotfiles..."
git clone https://github.com/ridhwaans/dotfiles.git $HOME/dotfiles && cd $_

echo "Setting up submodules..."
git submodule add -f https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
git submodule add -f https://github.com/zsh-users/antigen.git .zsh/bundle
git submodule add -f https://github.com/nvm-sh/nvm.git .nvm
git submodule add -f https://github.com/pyenv/pyenv.git .pyenv
cd .pyenv
git submodule add -f https://github.com/pyenv/pyenv-virtualenv.git plugins/pyenv-virtualenv
cd ..
git submodule add -f https://github.com/rbenv/rbenv.git .rbenv
cd .rbenv
git submodule add -f https://github.com/rbenv/ruby-build.git plugins/ruby-build
git submodule add -f https://github.com/jf/rbenv-gemset.git plugins/rbenv-gemset
cd ..

export SDKMAN_DIR=$PWD/.sdkman && curl https://get.sdkman.io | bash

echo "Clearing any automatically staged files..."
git reset .

echo "Symlinking dotfiles..."
files=(
	.nvm
	.pyenv
	.rbenv
	.sdkman
	.vim
	.zsh
	.gitconfig
	.vimrc
	.zshrc
)

for file in "${files[@]}"
do
	echo "ln -sf $PWD/$file $HOME/"
	ln -sf $PWD/$file $HOME/
done;

mkdir -p $HOME/.ssh && ln -sf $PWD/.ssh/autokey-github.sh $_/autokey-github.sh

if [[ -n "$WSL_DISTRO_NAME" ]]; then
    echo "Symlinking dotfiles to Windows user home..."
	ln -sf $PWD $(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')/dotfiles
fi

echo "Setting user shell..."
sudo usermod -s $(which zsh) $(whoami)
$(which zsh)
grep $(whoami) /etc/passwd

echo "Fixing oh-my-zsh theme..."
sudo apt install -y language-pack-en 
sudo update-locale

echo "Fixing oh-my-zsh powerline font..."
curl -L https://github.com/powerline/fonts/raw/master/RobotoMono/Roboto%20Mono%20for%20Powerline.ttf --create-dirs -o $HOME/.local/share/fonts/"Roboto Mono for Powerline.ttf"
fc-cache -f -v 
fc-list | grep Powerline

echo "Installing vim plugins..."
vim +silent! +PluginInstall +qall