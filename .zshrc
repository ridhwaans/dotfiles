alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

export EDITOR=/usr/bin/vim

export ADOTDIR=$HOME/.zsh/bundle

export WINDOWS_HOME=/mnt/c/Users/ridhwaan

#DEPRECATED export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
export JAVA_HOME=$(/usr/libexec/java_home)

export GROOVY_HOME=/usr/local/opt/groovy/libexec

export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/mysql/lib

export PYENV_ROOT=$HOME/.pyenv

export RBENV_ROOT=$HOME/.rbenv

export JENV_ROOT=$HOME/.jenv

export PYTHONPATH='.'

# PATH

export PATH=$PATH:$PYENV_ROOT/bin

export PATH=$PATH:$RBENV_ROOT/bin

export PATH=$PATH:$JENV_ROOT/bin

export PATH=$PATH:$HOME/bin

export PATH=$PATH:$HOME/.local/bin

export PATH=$PATH:/usr/local/opt/openssl/bin

export PATH=$PATH:/usr/local/bin

export PATH=$PATH:/usr/local/mysql/bin

export PATH=$PATH:/Library/Python/2.7/bin

export PATH=$PATH:/usr/local/Cellar/khd/2.0.0/bin

export PATH=$PATH:/usr/local/Cellar/kwm/4.0.4

export PATH=$PATH:/mnt/c/Program\ Files/Docker/Docker/resources/bin

export PATH=$PATH:/mnt/c/Program\ Files/Sublime\ Text\ 3

export PATH=$PATH:/opt/gradle/gradle-3.5.1/bin
export PATH=$PATH:/mnt/c/Program\ Files/MySQL/MySQL\ Server\ 5.7/bin

eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
eval "$(jenv init -)"

# TERMINAL EMULATOR

#(MAC) ITerm2 -> iTerm2 3.2.9
#Profiles -> Window -> Style -> no Title Bar
#Profiles -> Terminal -> Environment -> set locale variables manually
#Font -> Roboto Mono for Powerline
#Color Preset -> Gotham

#(WINDOWS) HyperTerm -> Hyper 3.0.2 (stable)
#Font -> Roboto Mono for Powerline
#Plugins -> hyperterm-gotham (0.0.1)

source $HOME/.zsh/bundle/bin/antigen.zsh

antigen use oh-my-zsh # Load the oh-my-zsh's library.

# Bundles from oh-my-zsh.
antigen bundle git
# Color schemes
antigen theme agnoster

antigen apply # Tell antigen that you're done.
