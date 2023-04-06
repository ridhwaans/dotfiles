#!/bin/bash

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

function set-url-ssh() {
  # Switch remote URL from HTTPS to SSH
  if is-ssh-authenticated; then
      GIT_USER=`echo $(git config --get remote.origin.url) | sed -Ene's#https://github.com/([^/]*)/(.*).git#\1#p'`
      GIT_REPO=$(basename `git rev-parse --show-toplevel`)
      git remote set-url origin git@github.com:$GIT_USER/$GIT_REPO.git
      echo "Set $GIT_REPO remote URL to SSH"
  fi
  # Credits
  # https://stackoverflow.com/a/53454540/3577482
}

function install-vscode-extensions() {
  code --install-extension PKief.material-icon-theme
  code --install-extension alireza94.theme-gotham
  code --install-extension eamodio.gitlens
  code --install-extension ms-vscode-remote.remote-containers
  code --install-extension 	ms-vscode-remote.remote-wsl	
  code --install-extension ms-vscode-remote.remote-ssh
}
