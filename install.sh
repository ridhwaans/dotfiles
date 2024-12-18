#!/usr/bin/env bash

set -e

start_time=$(date +%s)

SCRIPT_HOME="$(dirname $0)"

echo "For user ${USERNAME}"

echo "(1/3) Setting up IDE..."
if command -v code &>/dev/null; then
  while IFS= read -r extension || [ -n "$extension" ]; do
      code --install-extension "$extension"
  done < "$SCRIPT_HOME/vscode/extensions"
  code --install-extension alireza94.theme-gotham
  code --install-extension PKief.material-icon-theme
fi

if [ $(uname) = Darwin ]; then
	echo "(mac)"

	VSCODE_SETTINGS_DIR=$HOME/Library/Application\ Support/Code/User
	mkdir -p "$VSCODE_SETTINGS_DIR" && cp -f $SCRIPT_HOME/vscode/settings.json "$VSCODE_SETTINGS_DIR"/settings.json

elif [ $(uname) = Linux ]; then
	if [ -n "$WSL_DISTRO_NAME" ]; then
		echo "(wsl)"

    WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')

		VSCODE_SETTINGS_DIR=$WINDOWS_HOME/AppData/Roaming/Code/User
		mkdir -p $VSCODE_SETTINGS_DIR && cp -f $SCRIPT_HOME/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json
		# https://github.com/microsoft/vscode/issues/1022
		# https://github.com/microsoft/vscode/issues/166680

	elif [ -n "$CODESPACES" ]; then
		echo "(github codespaces)"
	else
		echo "(native linux)"

		VSCODE_SETTINGS_DIR=$HOME/.config/Code/User
		mkdir -p $VSCODE_SETTINGS_DIR && cp -f $SCRIPT_HOME/vscode/settings.json $VSCODE_SETTINGS_DIR/settings.json
	fi
fi

echo "(2/3) Setting up terminal emulator..."
if [ $(uname) = Darwin ]; then
	echo "(mac)"

  # Terminal
	curl -L https://raw.githubusercontent.com/whatyouhide/gotham-contrib/master/terminal.app/Gotham.terminal --create-dirs -o $HOME/.local/share/themes/"Gotham.terminal"
	# ~/Library/Preferences/com.apple.Terminal.plist

  # iTerm2
	curl -L https://raw.githubusercontent.com/whatyouhide/gotham-contrib/master/iterm2/Gotham.itermcolors --create-dirs -o $HOME/.local/share/themes/"Gotham.itermcolors"
  # ~/Library/Application Support/iTerm2/DynamicProfiles

elif [ $(uname) = Linux ]; then
	if [ -n "$WSL_DISTRO_NAME" ]; then
		echo "(wsl)"

		WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')
    # Windows Terminal
		# ${WINDOWS_HOME}/AppData/Local/Packages/Microsoft.WindowsTerminal*/LocalState/settings.json

	elif [ -n "$CODESPACES" ]; then
		echo "(github codespaces)"
	else
		echo "(native linux)"
	fi
fi

echo "(3/3) Setting up home files & permissions..."
configs=(
	.gitconfig
  .tmux.conf
	.vimrc
	.zshrc
)
for config in "${configs[@]}"; do
  [ -L "$HOME/$config" ] && rm "$HOME/$config" && echo "Symlink found and removed at $HOME/$config"
	cp "$SCRIPT_HOME/$config" "$HOME/" && echo "Copied $SCRIPT_HOME/$config to $HOME/"
done;

if [ -n "$WINDOWS_HOME" ]; then
  echo "(wsl)"
  ln -sf $HOME $WINDOWS_HOME/$(basename $HOME)
fi

if [ -z "$CODESPACES" ] && [ -d "$HOME/.ssh/" ]; then
    find $HOME/.ssh/ -type f -exec chmod 600 {} \;
    find $HOME/.ssh/ -type d -exec chmod 700 {} \;
    find $HOME/.ssh/ -type f -name "*.pub" -exec chmod 644 {} \;
fi

#gh auth login -h 'github.com' -p 'ssh' --skip-ssh-key -w
# https://gist.github.com/ridhwaans/08f2fc5e9b3614a3154cef749a43a568
mkdir -p "$HOME/Source" && curl -sfSL "https://gist.githubusercontent.com/ridhwaans/08f2fc5e9b3614a3154cef749a43a568/raw/scripts.sh" -o "$HOME/Source/scripts.sh" && chmod +x "$HOME/Source/scripts.sh"

# Moving to end because it lapses trailing code
sudo -u $USERNAME vim +silent! +PlugInstall +PlugClean +qall

echo "Done!"

end_time=$(date +%s)
elapsed=$(( end_time - start_time ))
echo "Install took $elapsed seconds."

exit $?
