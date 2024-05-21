# ***********
# ** zplug **
# ***********

export LANG=en_US.UTF-8

export ZPLUG_HOME="~/.zsh/bundle"

export ZPLUG_PATH="/usr/local/share/zsh/bundle"

source $ZPLUG_PATH/init.zsh

zplug "agnoster/3712874", from:gist, as:theme, use:agnoster.zsh-theme

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose

# **********************
# ** Helper functions **
# **********************

[ -f $HOME/Source/scripts.sh ] && source $HOME/Source/scripts.sh

# ***************************
# ** Aliases and home vars **
# ***************************

alias cds='[ -d $HOME/Source ] && cd $HOME/Source'
alias cddf='[ -d $HOME/Source/environment/dotfiles ] && cd $HOME/Source/environment/dotfiles'
alias edc='[ -d $HOME/Source/environment/devcontainer-features ] && code $HOME/Source/environment/devcontainer-features'
alias edf='[ -d $HOME/Source/environment/dotfiles ] && code $HOME/Source/environment/dotfiles'
alias es='[ -f $HOME/Source/scripts.sh ] && code $HOME/Source/scripts.sh'

if [ $(uname) = Darwin ]; then
  # Command + Shift + . (the period key) shows hidden files in Finder
  alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

  alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

  alias sleepoff='sudo pmset -a disablesleep 1'

  alias sleepon='sudo pmset -a disablesleep 0'

  defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Bluetooth -int 18
  defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18
  defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Display -int 18

  defaults write com.apple.finder ShowPathbar -bool true
  # Do not display prompt when quitting iTerm
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false
  # Stop `Music.app` from opening
  launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist

  export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/mysql/lib

  eval $(/opt/homebrew/bin/brew shellenv)
fi

if [ -n "$WSL_DISTRO_NAME" ]; then
  export WINDOWS_USER=$(powershell.exe '$env:UserName')
  # Also removes the ^M, carriage return character from DOS
  export WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')

  alias cdw='cd $WINDOWS_HOME'

  ln -sf $HOME $WINDOWS_HOME/$HOME

  export PATH=$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin
fi

if [ -n "$CODESPACES" ]; then
fi

export EDITOR="/usr/bin/vim"

export PATH="$PATH:$HOME/bin"

export PATH="$PATH:$HOME/.local/bin"

# ***********************
# ** Language managers **
# ***********************

export SDKMAN_DIR="/usr/local/sdkman"

[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

if [ $(uname) = Linux ]; then
  export PYENV_ROOT="/usr/local/pyenv"

  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

  export RBENV_ROOT="/usr/local/rbenv"

  [[ -d $RBENV_ROOT/bin ]] && export PATH="$RBENV_ROOT/bin:$PATH"  
fi

eval "$(pyenv init -)"

eval "$(pyenv virtualenv-init -)"

eval "$(rbenv init -)"

export NVM_DIR="/usr/local/nvm"

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

export PATH="/usr/local/go/bin:$PATH"

export GOPATH="/go"
