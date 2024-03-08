# **********************
# ** Helper functions **
# **********************

[ -f $HOME/Source/scripts.sh ] && source $HOME/Source/scripts.sh

# *************************
# ** Alises and env vars **
# *************************

alias ed='[ -d $HOME/Source/environment/dotfiles ] && code $HOME/Source/environment/dotfiles'
alias cdd='[ -d $HOME/Source/environment/dotfiles ] && cd $HOME/Source/environment/dotfiles'
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

        ln -sf $HOME $WINDOWS_HOME/$HOME
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
