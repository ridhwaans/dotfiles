#!/usr/bin/env bash

if [ $(uname) = Darwin ]; then
	# Write permissions for Homebrew
	sudo chown -R $(whoami) /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig
	chmod u+w /usr/local/include /usr/local/lib /usr/local/lib/pkgconfig

	# Install Homebrew if missing
	if test ! $(which brew)
	then
		echo "Installing Homebrew..."
		bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
    cfn-lint
		exercism
		fontconfig
		git
		go
		jq
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
    hpedrorodrigues/tools/dockutil
		iterm2-nightly
		mounty
		notion
		postman
		steam
		visual-studio-code
	)

    if [ ! -d "/Applications/Google Chrome.app" ]; then
        apps+=(google-chrome);
    fi

    if [ ! -d "/Applications/Slack.app" ]; then
        apps+=(slack);
    fi

    if [ ! -d "/Applications/zoom.us.app" ]; then
        apps+=(zoom);
    fi

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
    'Beekeeper Studio'
		Postman
		Notion
		Slack
		Figma
		zoom.us
    Docker
		'System Settings'
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

    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Bluetooth -int 18
    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18
    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Display -int 18
    # Stop `Music.app` from opening
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
fi

echo "Setting up dotfiles..."
rm -rf $HOME/dotfiles && git clone https://github.com/ridhwaans/dotfiles.git $HOME/dotfiles && cd $_

echo "Setting up language managers..."
git clone https://github.com/zsh-users/antigen.git .zsh/bundle
git clone https://github.com/VundleVim/Vundle.vim .vim/bundle/Vundle.vim

git clone https://github.com/nvm-sh/nvm.git .nvm
git clone https://github.com/pyenv/pyenv .pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git .pyenv/plugins/pyenv-virtualenv
git clone https://github.com/rbenv/rbenv .rbenv
git clone https://github.com/rbenv/ruby-build.git .rbenv/plugins/ruby-build
git clone https://github.com/jf/rbenv-gemset.git .rbenv/plugins/rbenv-gemset

export SDKMAN_DIR=$PWD/.sdkman && curl https://get.sdkman.io | bash

echo "Symlinking dotfiles..."
files=(
  .zsh
  .vim
	.nvm
	.pyenv
	.rbenv
	.sdkman
	.gitconfig
	.vimrc
	.zshrc
)

for file in "${files[@]}"
do
	echo "ln -sf $PWD/$file $HOME/"
	ln -sf $PWD/$file $HOME/
done;

echo "Setting up .ssh folder permissions..."
mkdir -p $HOME/.ssh && ln -sf $PWD/.ssh/autokey-github.sh $_/autokey-github.sh
find $HOME/.ssh/ -type f -exec chmod 600 {} \;; find $HOME/.ssh/ -type d -exec chmod 700 {} \;; find $HOME/.ssh/ -type f -name "*.pub" -exec chmod 644 {} \;


echo "Setting up IDE..."
echo "Installing VSCode extensions..."
extensions=(
	alireza94.theme-gotham
  PKief.material-icon-theme
	dunstontc.viml
	eamodio.gitlens
	GitHub.codespaces
	GitHub.copilot
	ms-azuretools.vscode-docker
	ms-vscode-remote.remote-containers
	ms-vscode-remote.remote-ssh
	ms-vscode-remote.remote-wsl
	ms-vsliveshare.vsliveshare
  EditorConfig.EditorConfig
  dbaeumer.vscode-eslint
  GraphQL.vscode-graphql
  GraphQL.vscode-graphql-syntax
  Prisma.prisma
  rubocop.vscode-rubocop
  sorbet.sorbet-vscode-extension
)
if type -p code >/dev/null
then
    for extension in "${extensions[@]}"
    do
        code --install-extension $extension
    done
fi
if [ $(uname) = Darwin ]; then
	echo "(mac)"

	VSCODE_SETTINGS_DIR=$HOME/Library/Application\ Support/Code/User
	echo "mkdir -p $VSCODE_SETTINGS_DIR && ln -sf $PWD/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json"
	mkdir -p $VSCODE_SETTINGS_DIR && ln -sf $PWD/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json

elif [ $(uname) = Linux ]; then
	if [ -n "$WSL_DISTRO_NAME" ]; then
		echo "(wsl)"

		VSCODE_SETTINGS_DIR=$WINDOWS_HOME/AppData/Roaming/Code/User
		echo "mkdir -p $VSCODE_SETTINGS_DIR && cp --remove-destination $PWD/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json"
		mkdir -p $VSCODE_SETTINGS_DIR && cp --remove-destination $PWD/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json
		# https://github.com/microsoft/vscode/issues/1022
		# https://github.com/microsoft/vscode/issues/166680
	elif [ -n "$CODESPACES" ]; then
		echo "(github codespaces)"
	else
		echo "(native linux)"

		VSCODE_SETTINGS_DIR=$HOME/.config/Code/User
		echo "mkdir -p $VSCODE_SETTINGS_DIR && ln -sf $PWD/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json"
		mkdir -p $VSCODE_SETTINGS_DIR && ln -sf $PWD/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json
	fi
fi

echo "Setting up terminal emulator..."
if [ $(uname) = Darwin ]; then
	echo "(mac)"

	defaults write com.googlecode.iterm2 PromptOnQuit -bool false
	curl -L https://raw.githubusercontent.com/whatyouhide/gotham-contrib/master/iterm2/Gotham.itermcolors --create-dirs -o $HOME/.local/share/themes/"Gotham.itermcolors"
	curl -L https://raw.githubusercontent.com/whatyouhide/gotham-contrib/master/terminal.app/Gotham.terminal --create-dirs -o $HOME/.local/share/themes/"Gotham.terminal"
	curl -L https://github.com/powerline/fonts/raw/master/RobotoMono/Roboto%20Mono%20for%20Powerline.ttf --create-dirs -o $HOME/.local/share/fonts/"Roboto Mono for Powerline.ttf"

	open $HOME/.local/share/themes/"Gotham.itermcolors";ok
	cp $HOME/.local/share/fonts/"Roboto Mono for Powerline.ttf" ~/Library/Fonts
    # TODO Import terminal default profile (~/iterm2/Default.json)
elif [ $(uname) = Linux ]; then
	if [ -n "$WSL_DISTRO_NAME" ]; then
		echo "(wsl)"
        # Make a dotfiles shortcut in the Windows home directory
		WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')
		echo "ln -sf $PWD $WINDOWS_HOME/dotfiles"
		ln -sf $PWD $WINDOWS_HOME/dotfiles
		# TODO Import terminal default profile (ln -sf $PWD/windowsterminal/settings.json ${WINDOWS_HOME}/AppData/Local/Packages/Microsoft.WindowsTerminal*/LocalState/settings.json)
	elif [ -n "$CODESPACES" ]; then
		echo "(github codespaces)"
	else
		echo "(native linux)"
		# TODO Import terminal default profile
	fi
fi

# Moving to end because it lapses trailing code
echo "Installing vim plugins..."
vim +silent! +PluginInstall +qall
