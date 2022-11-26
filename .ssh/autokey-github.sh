#!/bin/bash

# Personal access token (classic) required
# OAuth token required scope -- repo, admin:public_key
# Usage
#   chmod +x autokey-github.sh
#   ./autokey-github.sh <KEY-TITLE> <YOUR-GITHUB-ACCESS-TOKEN>

#set -e

# Generate SSH Key and Deploy to Github

TOKEN=$2

ssh-keygen -t ed25519 -C $1 -f ~/.ssh/id_ed25519

PUBKEY=`cat ~/.ssh/id_ed25519.pub`
TITLE=$1

RESPONSE=`curl -s -H "Authorization: token ${TOKEN}" \
  -X POST --data-binary "{\"title\":\"${TITLE}\",\"key\":\"${PUBKEY}\"}" \
  https://api.github.com/user/keys`

KEYID=`echo $RESPONSE \
  | grep -o '\"id.*' \
  | grep -o "[0-9]*" \
  | grep -m 1 "[0-9]*"`

echo "Public key deployed to remote service"

# Add SSH Key to the local ssh-agent"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

echo "Added SSH key to the ssh-agent"

# Test the SSH connection

ssh -T git@github.com

function github-authenticated() {
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

# Switch remote URLs from HTTPS to SSH

if github-authenticated; then
  cd $HOME/dotfiles
  GIT_USER=`echo $(git config --get remote.origin.url) | sed -Ene's#https://github.com/([^/]*)/(.*).git#\1#p'`
  GIT_REPO=$(basename `git rev-parse --show-toplevel`)
  git remote set-url origin git@github.com:$GIT_USER/$GIT_REPO.git
  cd -
  echo "Switched dotfiles remote URL from HTTPS to SSH"
fi

# Credits
# https://gist.github.com/petersellars/c6fff3657d53d053a15e57862fc6f567
# https://stackoverflow.com/a/53454540/3577482

# References
# https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps
# https://docs.github.com/en/rest/users/keys#create-a-public-ssh-key-for-the-authenticated-user
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
