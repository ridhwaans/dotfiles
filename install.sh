#!/usr/bin/env bash

echo "Setting up dotfiles..."
rm -rf $HOME/dotfiles && git clone https://github.com/ridhwaans/dotfiles.git $HOME/dotfiles && cd $_

echo "Symlinking dotfiles..."
files=(
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
extensions=(
	dunstontc.viml
	eamodio.gitlens
	EditorConfig.EditorConfig
	PKief.material-icon-theme
	ms-azuretools.vscode-docker
	ms-vscode-remote.remote-containers
	ms-vscode-remote.remote-ssh
	ms-vscode-remote.remote-wsl
	ms-vsliveshare.vsliveshare
	GraphQL.vscode-graphql
	GraphQL.vscode-graphql-syntax
)
if type -p code >/dev/null
then
		for extension in "${extensions[@]}"
		do
				code --install-extension $extension
		done

    code --install-extension alireza94.theme-gotham
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

  curl -L https://github.com/powerline/fonts/raw/master/RobotoMono/Roboto%20Mono%20for%20Powerline.ttf --create-dirs -o $HOME/.local/share/fonts/"Roboto Mono for Powerline.ttf"
  cp $HOME/.local/share/fonts/"Roboto Mono for Powerline.ttf" ~/Library/Fonts

	curl -L https://raw.githubusercontent.com/whatyouhide/gotham-contrib/master/terminal.app/Gotham.terminal --create-dirs -o $HOME/.local/share/themes/"Gotham.terminal"
	open $HOME/.local/share/themes/"Gotham.itermcolors";ok

  curl -L https://raw.githubusercontent.com/whatyouhide/gotham-contrib/master/iterm2/Gotham.itermcolors --create-dirs -o $HOME/.local/share/themes/"Gotham.itermcolors"
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
echo "Setting up vim plugins..."
vim +silent! +PluginInstall +qall

echo "Done"
