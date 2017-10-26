alias subl='/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl'

alias showFiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'

alias hideFiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

export EDITOR=/usr/bin/vim

export ADOTDIR=$HOME/.zsh/bundle

#OLD export JAVA_HOME=/Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Home
export JAVA_HOME=$(/usr/libexec/java_home)

export SPARK_HOME=/usr/local/Cellar/apache-spark/2.1.0/libexec

export GROOVY_HOME=/usr/local/opt/groovy/libexec

export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:/usr/local/mysql/lib

export PYENV_ROOT=$HOME/.pyenv

export RBENV_ROOT=$HOME/.rbenv

export PYTHONPATH='.'

export PYTHONPATH=$PYTHONPATH:$SPARK_HOME/python/

# PATH

export PATH=$PATH:$PYENV_ROOT/bin

export PATH=$PATH:$RBENV_ROOT/bin

export PATH=$PATH:$HOME/Source/HealthCheck-2.0/bin

export PATH=$PATH:/usr/local/opt/openssl/bin

export PATH=$PATH:$HOME/.local/bin

export PATH=$PATH:/usr/local/bin

export PATH=$PATH:/usr/local/mysql/bin

export PATH=$PATH:/Library/Python/2.7/bin

export PATH=$PATH:/usr/local/Cellar/khd/2.0.0/bin

export PATH=$PATH:/usr/local/Cellar/kwm/4.0.4

eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# TERMINAL EMULATOR

# ITerm2 -> iterm2-nightly
# Profiles -> Window -> Style -> no Title Bar
# Profiles -> Terminal -> Environment -> set locale variables manually
# Font -> Roboto Mono for Powerline
# Color Preset -> Gotham

source $HOME/.zsh/bundle/bin/antigen.zsh

antigen use oh-my-zsh # Load the oh-my-zsh's library.

# Bundles from oh-my-zsh.
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle zsh-users/zsh-syntax-highlighting 
antigen bundle l4u/zsh-output-highlighting
antigen bundle rimraf/k
# Color schemes
antigen theme agnoster

antigen apply # Tell antigen that you're done.
