# **********************
# ** Helper functions **
# **********************

function is-ssh-authenticated() {
    # Attempt to ssh to GitHub
    ssh -T git@github.com > /dev/null 2>&1
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
    if [ -z "$1" ]; then
      echo "Cannot find path to submodule. Exiting."
      exit 1
    fi
    # Remove the submodule entry from .git/config
    git submodule deinit -f $1
    # Remove the submodule directory from the superproject's .git/modules directory
    rm -rf .git/modules/$1
    # Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
    git rm -f $1
}

function update-submodules() {
    git submodule update --init --recursive --remote
}

function reopen_in_container() {
    local IMAGE_NAME="${1:-"base"}"
    local CONTAINER_NAME="${2:-"instance"}"

    # Check if the container is already running
    if [ "$(docker inspect -f '{{.State.Running}}' $CONTAINER_NAME 2>/dev/null)" = "true" ]; then
        echo "Container $CONTAINER_NAME is already running."
    else
        # Check if the container exists but is stopped
        if [ "$(docker inspect -f '{{.State.Status}}' $CONTAINER_NAME 2>/dev/null)" = "exited" ]; then
            # Start the existing stopped container
            docker start -i $CONTAINER_NAME
        else
            echo "Building Docker image..."
            # Check if Dockerfile exists in the current directory
            if [ -f Dockerfile ]; then
                # Use the local Dockerfile
                docker build --no-cache -t "$IMAGE_NAME" . > build_log.txt 2>&1
            else
                echo "Dockerfile not found. Exiting."
                exit 1
            fi

            # Create and start a new container
            docker run -it --name $CONTAINER_NAME $IMAGE_NAME
        fi
    fi

    echo "Connecting to Docker container..."
    docker exec -it "$CONTAINER_NAME" /bin/bash
}

function cleanup_container() {
    local IMAGE_NAME="${1:-"base"}"
    local CONTAINER_NAME="${2:-"instance"}"

    if docker ps -a --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; then
        echo "Stopping and removing container: $CONTAINER_NAME"
        docker stop "$CONTAINER_NAME" && docker rm "$CONTAINER_NAME"
    else
        echo "Container $CONTAINER_NAME not found."
    fi

    if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "$IMAGE_NAME"; then
        echo "Removing image: $IMAGE_NAME"
        docker rmi "$IMAGE_NAME"
    else
        echo "Image $IMAGE_NAME not found."
    fi
}

# *************************
# ** Alises and env vars **
# *************************

alias ed='[ -d $HOME/dotfiles ] && code $HOME/dotfiles'
alias cdd='[ -d $HOME/dotfiles ] && cd $HOME/dotfiles'
alias cds='[ -d $HOME/Source ] && cd $HOME/Source'
alias touchsh='touch $1; chmod +x $1'

if [ $(uname) = Darwin ]; then
    # Command + Shift + . (the period key) shows hidden files in Finder
    alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

    alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

    alias sleepoff='sudo pmset -a disablesleep 1'

    alias sleepon='sudo pmset -a disablesleep 0'

    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Bluetooth -int 18
    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18
    defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Display -int 18

    # Do not display prompt when quitting iTerm
    defaults write com.googlecode.iterm2 PromptOnQuit -bool false
    # Stop `Music.app` from opening
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist

elif [ $(uname) = Linux ]; then
    if [ -n "$WSL_DISTRO_NAME" ]; then
        export WINDOWS_USER=$(powershell.exe '$env:UserName')
        # Also removes the ^M, carriage return character from DOS
        export WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')

        alias cdw='cd $WINDOWS_HOME'

        export VSCODE_SETTINGS=$WINDOWS_HOME/AppData/Roaming/Code/User/settings.json

    elif [ -n "$CODESPACES" ]; then
    else
    fi
fi

export EDITOR=/usr/bin/vim

export ZPLUG_HOME="/usr/local/share/.zsh/bundle"

export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

export SDKMAN_DIR="/usr/local/sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/mysql/lib

export GOPATH="/go"

# **********
# ** PATH **
# **********

export PATH=$PATH:/opt/homebrew/bin

export PATH=$PATH:$PYENV_ROOT/bin

export PATH=$PATH:$RBENV_ROOT/bin

export PATH=$PATH:$HOME/bin

export PATH=$PATH:$HOME/.local/bin

export PATH=$PATH:/usr/local/opt/openssl/bin

export PATH=$PATH:/usr/local/bin

export PATH=$PATH:/usr/local/mysql/bin

if [ $(uname) = Darwin ]; then
    export PATH=$PATH/opt/homebrew/opt/go/bin
elif [ $(uname) = Linux ]; then
    export PATH=$PATH:/usr/local/go/bin
    if [ -n "$WSL_DISTRO_NAME" ]; then
        export PATH=$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin
    fi
fi

eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# ***********
# ** zplug **
# ***********

source $ZPLUG_HOME/init.zsh

zplug "agnoster/3712874", from:gist, as:theme, use:agnoster.zsh-theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose