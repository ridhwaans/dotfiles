#!/usr/bin/env bash

set -e

cd $(dirname $0)

echo "Setting up initial folders & permissions..."
mkdir -p $HOME/Source $HOME/.ssh
find $HOME/.ssh/ -type f -exec chmod 600 {} \;; find $HOME/.ssh/ -type d -exec chmod 700 {} \;; find $HOME/.ssh/ -type f -name "*.pub" -exec chmod 644 {} \;

echo "Setting up IDE..."
if ! command -v code &>/dev/null; then
  while IFS= read -r extension || [ -n "$extension" ]; do
      code --install-extension "$extension"
  done < "$PWD/vscode/extensions.txt"
fi

if [ $(uname) = Darwin ]; then
	echo "(mac)"

	VSCODE_SETTINGS_DIR=$HOME/Library/Application\ Support/Code/User
	mkdir -p "$VSCODE_SETTINGS_DIR" && ln -sf $PWD/vscode/settings.json "$VSCODE_SETTINGS_DIR"/settings.json

elif [ $(uname) = Linux ]; then
	if [ -n "$WSL_DISTRO_NAME" ]; then
		echo "(wsl)"

    WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')

		VSCODE_SETTINGS_DIR=$WINDOWS_HOME/AppData/Roaming/Code/User
		mkdir -p $VSCODE_SETTINGS_DIR && cp --remove-destination $PWD/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json
		# https://github.com/microsoft/vscode/issues/1022
		# https://github.com/microsoft/vscode/issues/166680

	elif [ -n "$CODESPACES" ]; then
		echo "(github codespaces)"
	else
		echo "(native linux)"

		VSCODE_SETTINGS_DIR=$HOME/.config/Code/User
		mkdir -p $VSCODE_SETTINGS_DIR && ln -sf $PWD/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json
	fi
fi

echo "Setting up terminal emulator..."
if [ $(uname) = Darwin ]; then
	echo "(mac)"

  # Terminal
	curl -L https://raw.githubusercontent.com/whatyouhide/gotham-contrib/master/terminal.app/Gotham.terminal --create-dirs -o $HOME/.local/share/themes/"Gotham.terminal"

	# iTerm2
	curl -L https://raw.githubusercontent.com/whatyouhide/gotham-contrib/master/iterm2/Gotham.itermcolors --create-dirs -o $HOME/.local/share/themes/"Gotham.itermcolors"
	#open $HOME/.local/share/themes/"Gotham.itermcolors";ok

elif [ $(uname) = Linux ]; then
	if [ -n "$WSL_DISTRO_NAME" ]; then
		echo "(wsl)"

		WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')
    # Windows Terminal
		# TODO (ln -sf $PWD/windowsterminal/settings.json ${WINDOWS_HOME}/AppData/Local/Packages/Microsoft.WindowsTerminal*/LocalState/settings.json)
	elif [ -n "$CODESPACES" ]; then
		echo "(github codespaces)"
	else
		echo "(native linux)"
		# TODO Import terminal default profile
	fi
fi

echo "Symlinking dotfiles..."
files=(
	.gitconfig
	.vimrc
	.zshrc
)

for file in "${files[@]}"
do
	ln -sf $PWD/$file $HOME/
done;

if [ -n "$WINDOWS_HOME" ]; then
  ln -sf $PWD $WINDOWS_HOME/dotfiles
fi

# Moving to end because it lapses trailing code
echo "Installing vim plugins..."
vim +silent! +PlugInstall +qall

echo "Done"

