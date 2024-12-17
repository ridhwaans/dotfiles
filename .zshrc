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

if [ -f "$HOME/Source/scripts.sh" ]; then
    echo "Sourcing bash-compatible helper functions in zsh..."

    # Trap to capture errors
    error_message=""
    trap 'error_message="Error: $BASH_COMMAND failed at line $LINENO"' ERR

    if emulate bash -c "source $HOME/Source/scripts.sh"; then
        echo "Source successful"
    else
        echo "An error occurred. Source skipped"
        echo "$error_message"
    fi

    # Reset the trap to avoid affecting subsequent commands
    trap - ERR
fi

function start_tmux_sessions() {
  # List of directories for each session
  local sessions=(
    "~/Source/test"
    "~/Source/environment/devcontainer-features"
    "~/Source/environment/dotfiles"
    "~/Source/practice-vault"
  )

  # Check if tmux is already running
  if ! tmux has-session 2>/dev/null; then
    # tmux is not running, create and start sessions

    # Loop through each session
    for session in "${sessions[@]}"; do
      # Expand ~ to full path
      local expanded_session=$(eval echo $session)

      # Check if the session directory exists
      if [[ ! -d "$expanded_session" ]]; then
        echo "Directory $expanded_session does not exist. Skipping session."
        continue
      fi

      # Get the session name (last part of the path)
      local session_name=$(basename "$expanded_session")

      # Check if the tmux session exists, if not, create it in the specified directory
      if ! tmux has-session -t "$session_name" 2>/dev/null; then
        tmux new-session -d -s "$session_name" -c "$expanded_session"
      fi
    done
  fi

  # If we are inside tmux, switch to the last session in the list
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "${sessions[-1]}"
  else
    # Attach to the last session if outside tmux
    tmux attach-session -t "${sessions[-1]}"
  fi
}

function tmux_session_selector() {
    if [[ $# -eq 1 ]]; then
        local selected=$1
    else
        local selected=$(find ~/Source -mindepth 1 -maxdepth 1 -type d | fzf)
    fi

    if [[ -z $selected ]]; then
        return 0
    fi

    local selected_name=$(basename "$selected" | tr . _)
    local tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s $selected_name -c $selected
        return 0
    fi

    if ! tmux has-session -t=$selected_name 2> /dev/null; then
        tmux new-session -ds $selected_name -c $selected
    fi

    tmux switch-client -t $selected_name
}

# ***************************
# ** Aliases and home vars **
# ***************************

export $HISTFILE="$HOME/.zsh_history"
export EDITOR="/usr/bin/vim"
export SUDO_EDITOR="$EDITOR"

alias evi="$EDITOR $HOME/.vimrc"
alias ezsh="$EDITOR $HOME/.zshrc"
alias et="$EDITOR $HOME/.tmux.conf"
alias es="[ -f $HOME/Source/scripts.sh ] && $EDITOR $HOME/Source/scripts.sh"

# tmux
alias ta='tmux attach -t'
alias tn='tmux new-session -s'
alias tls='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

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

export BUN_INSTALL="/usr/local/.bun"

export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="/usr/local/go/bin:$PATH"

export GOPATH="/go"

# for those who prefer to use a script instead of a terminal emulator theme
GOTHAM_SHELL="$HOME/.local/share/themes/gotham.sh"

[[ -s $GOTHAM_SHELL ]] && source $GOTHAM_SHELL
