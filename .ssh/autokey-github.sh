#!/bin/bash

# Usage
#   chmod +x autokey-github.sh
#   ./autokey-github.sh <KEY-TITLE> <YOUR-GITHUB-ACCESS-TOKEN>

# Credit
# https://gist.github.com/petersellars/c6fff3657d53d053a15e57862fc6f567

# References
# https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps
# Personal access tokens (classic)
# OAuth token required scope -- repo, admin:public_key
# https://docs.github.com/en/rest/overview/permissions-required-for-fine-grained-personal-access-tokens

# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# https://docs.github.com/en/rest/users/keys#create-a-public-ssh-key-for-the-authenticated-user

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

# Switch remote URLs from HTTPS to SSH

if ssh -T git@github.com | grep -q 'successfully authenticated'; then
  cd $HOME/dotfiles
  USER=`echo $(git config --get remote.origin.url) | sed -Ene's#https://github.com/([^/]*)/(.*).git#\1#p'`
  REPO=$(basename `git rev-parse --show-toplevel`)
  git remote set-url origin git@github.com:$USER/$REPO.git
  cd -
  echo "Switched remote URLs from HTTPS to SSH"
fi