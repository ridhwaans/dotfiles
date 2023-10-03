function is-ssh-authenticated() {
	# Attempt to ssh to GitHub
	ssh -T git@github.com &>/dev/null
	RET=$?
	if [ $RET == 1 ]; then
		# user is authenticated, but fails to open a shell with GitHub
		return 0
	elif [ $RET == 255 ]; then
		# user is not authenticated
		return 1
	else
		echo "unknown exit code in attempt to ssh into git@github.com"
	fi
	return 2
}

# Switch remote URL from HTTPS to SSH
function set-url-ssh() {
	if is-ssh-authenticated; then
		GIT_USER=`echo $(git config --get remote.origin.url) | sed -Ene's#https://github.com/([^/]*)/(.*).git#\1#p'`
		GIT_REPO=$(basename `git rev-parse --show-toplevel`)
		git remote set-url origin git@github.com:$GIT_USER/$GIT_REPO.git
		echo "Set $GIT_REPO remote URL to SSH"
	fi
	# Credits
	# https://stackoverflow.com/a/53454540/3577482
}

function rm-submodule() {
	# Requires path/to/submodule
    # Remove the submodule entry from .git/config
    git submodule deinit -f $1
    # Remove the submodule directory from the superproject's .git/modules directory
    rm -rf .git/modules/$1
    # Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
    git rm -f $1
}

function update-dotfiles() {
	cd ~/dotfiles
	git submodule update --init --recursive --remote
	git -C .pyenv/plugins/pyenv-virtualenv pull
	git -C .rbenv/plugins/ruby-build pull
	git -C .rbenv/plugins/rbenv-gemset pull
	sdk update
}

# Build docker image by 'name:tag' format, show and logs and also save them to file
function dci {
    docker build -t $1 --no-cache --progress=plain . 2>&1 | tee build.log
}

# Create a new container from an image
function dcc {
    docker run -it $1
}

# Start and attach to last exited container
alias dsal='docker start `docker ps -q -l`; docker attach `docker ps -q -l`'

# Stops then removes all running containers by 'name:tag' format
function drmc {
    docker rm $(docker stop $(docker ps -a -q --filter ancestor=$1 --format='{{.ID}}'))
}

alias ed='code $HOME/dotfiles'
alias cdd='cd $HOME/dotfiles'
alias cds='[ -d $HOME/Source ] && cd $HOME/Source'

if [ $(uname) = Darwin ]; then
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

elif [ $(uname) = Linux ]; then
    if [ -n "$WSL_DISTRO_NAME" ]; then
        export WINDOWS_USER=$(powershell.exe '$env:UserName')
        # Also removes the ^M, carriage return character from DOS
        export WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')

        alias cdw='cd $WINDOWS_HOME'

        export VSCODE_SETTINGS=$WINDOWS_HOME/AppData/Roaming/Code/User/settings.json

        export PATH=$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin

    elif [ -n "$CODESPACES" ]; then
    else
    fi
fi

export EDITOR=/usr/bin/vim

export ADOTDIR=$HOME/.zsh/bundle

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

export PYENV_ROOT=$HOME/.pyenv

export RBENV_ROOT=$HOME/.rbenv

export PYTHONPATH='.'

export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/mysql/lib

# PATH

export PATH=$PATH:/opt/homebrew/bin

export PATH=$PATH:$PYENV_ROOT/bin

export PATH=$PATH:$RBENV_ROOT/bin

export PATH=$PATH:$HOME/bin

export PATH=$PATH:$HOME/.local/bin

export PATH=$PATH:/usr/local/opt/openssl/bin

export PATH=$PATH:/usr/local/bin

export PATH=$PATH:/usr/local/mysql/bin

export PATH=$PATH:/usr/local/go/bin

eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

source $HOME/.zsh/bundle/bin/antigen.zsh

antigen use oh-my-zsh # Load the oh-my-zsh's library.
antigen theme agnoster # Load the theme.
antigen apply # Tell antigen that you're done.
