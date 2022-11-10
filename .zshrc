alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias cds='cd $HOME/Source'

# Build docker image by 'name:tag' format, show and logs and also save them to file
function dci {
    docker build -t $1 --no-cache --progress=plain . 2>&1 | tee build.log
}

# Create a new container from an image
function dcc {
    docker run -it $1
}

# Start and attach to last exited container
alias dscl='docker start `docker ps -q -l`; docker attach `docker ps -q -l`'

# Stops then removes all running containers by 'name:tag' format
function drmc {
    docker rm $(docker stop $(docker ps -a -q --filter ancestor=$1 --format='{{.ID}}'))
}

# Rmoves all dangling images
alias drmi='docker rmi $(docker images -f dangling=true -q)'

if [[ -n "$WSL_DISTRO_NAME" ]]; then

    export WINDOWS_USER=$(powershell.exe '$env:UserName')
    # Also removes the ^M, carriage return character from DOS
    export WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')

    alias cdw='cd $WINDOWS_HOME'

    export PATH=$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin
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