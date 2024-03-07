# **********************
# ** Helper functions **
# **********************

set -e

function autokey-github(){
  # Generating a new SSH key
  local KEY_TITLE=$1
  local GH_TOKEN=$2

  defaults=("id_dsa" "id_ecdsa" "id_ed25519" "id_rsa")
  if [[ ! " ${defaults[*]} " =~ " ${KEY_TITLE} " ]]; then
      echo "SSH key pair doesn't use a default name. IdentityFile must be configured in ~/.ssh/config"
  fi

  ssh-keygen -t ed25519 -C $KEY_TITLE -f ~/.ssh/$KEY_TITLE

  PUBLIC_KEY=`cat ~/.ssh/$KEY_NAME.pub`

  # Adding your SSH key to the ssh-agent
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/$KEY_TITLE

  # Adding a new SSH key to your account
  RESPONSE=`curl -s -H "Authorization: token ${GH_TOKEN}" \
    -X POST --data-binary "{\"title\":\"${KEY_TITLE}\",\"key\":\"${PUBLIC_KEY}\"}" \
    https://api.github.com/user/keys`

  KEY_ID=`echo $RESPONSE \
    | grep -o '\"id.*' \
    | grep -o "[0-9]*" \
    | grep -m 1 "[0-9]*"`

  echo "Public key deployed to remote service"

  # Testing your SSH connection
  ssh -T git@github.com
}

function switch_remote() {
    # Get current remote URL
    current_url=$(git config --get remote.origin.url)

    # Check if current URL starts with "https://"
    if [[ $current_url == https://* ]]; then
        # Replace "https://" with "git@"
        ssh_url=${current_url/https:\/\//git@}

        # Replace ".git" with ".git"
        ssh_url=${ssh_url%.git}.git

        # Set the new SSH URL
        git remote set-url origin $ssh_url

        echo "Remote URL updated to SSH:"
        echo "$ssh_url"
    else
        echo "Remote URL is already using SSH:"
        echo "$current_url"
    fi
}

function cherry-pick() {
    local default_branch=$(git remote show origin | grep 'HEAD branch' | cut -d ':' -f 2 | xargs)
    local your_branch_name="$1"
    local your_branch_backup="${your_branch_name}-backup"
    local exclusive_commits=$(git log ${your_branch_backup} ^master --pretty=%H)

    # Backup the branch and switch to default branch (e.g. main)
    git branch -m "$your_branch_backup" "${your_branch_backup}"
    git switch $default_branch

    # Create and switch to your branch
    git switch -c "$your_branch_name"

    # Cherry-pick commits from backup branch
    for commit_sha in $exclusive_commits; do
        git cherry-pick --no-commit "$commit_sha"
    done
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

function pull-recursive() {
  _inner() {
    local submodule_path=$1
    pull-recursive "$submodule_path"
  }

  local repo_path=${1:-$(git rev-parse --show-toplevel)}
  local default_branch=$(git remote show origin | grep 'HEAD branch' | cut -d ':' -f 2 | xargs)

  # Stash changes if there are any
  if [ -n "$(git -C "$repo_path" status --porcelain)" ]; then
      git -C "$repo_path" stash save "Stashed changes before switching branches"
  fi

  # Change to repo root directory
  cd "$repo_path" || return

  # Determine and checkout default branch (e.g. main)
  git checkout "$default_branch"

  # Pull latest changes
  git pull

  # Switch back to previous branch
  git checkout -

  # Pop stashed changes if any
  [ -n "$(git -C "$repo_path" stash list)" ] && git -C "$repo_path" stash pop

  # Handle submodules recursively
  git submodule foreach --recursive $_inner
}

function touchsh() {
    touch "$1"
    chmod +x "$1"
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

export LANG=en_US.UTF-8

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
