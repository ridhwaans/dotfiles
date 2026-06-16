export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

export PATH="$XDG_BIN_HOME:$PATH"

if [ $(uname) = Darwin ]; then
  eval $(/opt/homebrew/bin/brew shellenv)
fi

# ***********
# ** zplug **
# ***********

export ZPLUG_HOME="$XDG_DATA_HOME/zplug"

source $ZPLUG_HOME/init.zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose
autoload -Uz compinit
compinit

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

if [ $(uname) = Darwin ]; then
  # Command + Shift + . (period) shows hidden files in Finder
  function showHiddenFiles() {
    defaults write com.apple.finder AppleShowAllFiles YES
    killall Finder /System/Library/CoreServices/Finder.app
  }

  function hideHiddenFiles() {
    defaults write com.apple.finder AppleShowAllFiles NO
    killall Finder /System/Library/CoreServices/Finder.app
  }

  function sleepoff() {
    sudo pmset -a disablesleep 1
  }

  function sleepon() {
    sudo pmset -a disablesleep 0
  }

  showHiddenFiles
fi

# ***************************
# ** Aliases and home vars **
# ***************************

export LANG=en_US.UTF-8
export EDITOR="code"
export FZF_DEFAULT_OPTS="--layout=reverse"

export ENVIRONMENT_DIR="$HOME/Source/environment"
export DOTFILES_DIR="$HOME/Source/dotfiles"
export APPEARANCE_DIR="$HOME/Source/appearance"
ln -sf $ENVIRONMENT_DIR/bin/dotenv "$XDG_BIN_HOME/dotenv"

# *****************
# ** Shell theme **
# *****************

THEME_NAME=""

THEME_FILE="$APPEARANCE_DIR/src/themes/$THEME_NAME/theme.sh"

[[ -n "$THEME_NAME" && -s "$THEME_FILE" ]] && source "$THEME_FILE"

# ******************
# ** Prompt theme **
# ******************

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship.toml"

eval "$(mise activate zsh)"
[[ -f "$STARSHIP_CONFIG" ]] && eval "$(starship init zsh)"

# https://vi.stackexchange.com/questions/37639/viminit-conflicts-for-neovim-and-vim
alias vim="vim -u $XDG_CONFIG_HOME/vim/vimrc"
alias vi="vi -u $XDG_CONFIG_HOME/vim/vimrc"

function nvims() {
  items=("default" "LazyVim" "JonathanGin52Nvim" "craftzdogNvim" "kennethnymNvim" "kickstart.nvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}


alias cds="cd $HOME/Source"
alias cde="cd $HOME/Source/environment"
alias cdd="cd $HOME/Source/dotfiles"
alias ee="$EDITOR $HOME/Source/environment"
alias ed="$EDITOR $HOME/Source/dotfiles"
alias evi="$EDITOR $XDG_CONFIG_HOME/vim/vimrc"
alias envim="$EDITOR $XDG_CONFIG_HOME/nvim"
alias ezsh="$EDITOR $XDG_CONFIG_HOME/zsh/.zshrc"
alias es="[ -f $HOME/Source/scripts.sh ] && $EDITOR $HOME/Source/scripts.sh"

alias weather="curl http://v2.wttr.in"

if [ $(uname) = Darwin ]; then
  defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Bluetooth -int 18
  defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18
  defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Display -int 18

  defaults write -g com.apple.keyboard.fnState -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false
  # Don't open `Music.app`
  launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist

  export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/mysql/lib
fi

if [ -n "$WSL_DISTRO_NAME" ]; then
  export WINDOWS_USER=$(powershell.exe '$env:UserName')
  # Also removes the ^M, carriage return character from DOS
  export WINDOWS_HOME=$(wslpath $(powershell.exe '$env:UserProfile') | sed -e 's/\r//g')

  alias cdw='cd $WINDOWS_HOME'

  ln -sf $HOME $WINDOWS_HOME/$(basename $HOME)

  export PATH=/mnt/c/Program\ Files/Docker/Docker/resources/bin:$PATH

  # https://github.com/zellij-org/zellij/issues/3379#issuecomment-2135062888
  sudo mkdir $XDG_RUNTIME_DIR
  sudo chown $USER:$USER $XDG_RUNTIME_DIR
fi

if [ -n "$CODESPACES" ]; then
fi

setopt PROMPT_SUBST # enable command substitution in prompt (for shell prompt theme)
setopt NO_CASE_GLOB # allows case-insensitive tab completion

# *************
# ** History **
# *************

export HISTFILE="$XDG_STATE_HOME/zsh/history"

export HISTSIZE=50000
export SAVEHIST=10000

setopt APPEND_HISTORY INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_REDUCE_BLANKS
fc -R
