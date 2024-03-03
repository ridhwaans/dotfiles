#!/usr/bin/env bash

# Personal access token (PAT)
# Token (classic)
# scopes -- repo, admin:public_key
# no expiration date, or set a 90 day expiration to authorize single-sign-on organization access
# 
# Usage:
#   chmod +x autokey-github.sh
#   ./autokey-github.sh <KEY_TITLE> <GH_TOKEN>

set -e

# Generating a new SSH key
KEY_TITLE=$1
GH_TOKEN=$2

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

# Credits
# https://gist.github.com/petersellars/c6fff3657d53d053a15e57862fc6f567
# https://stackoverflow.com/a/53454540/3577482

# References
# https://docs.github.com/en/developers/apps/building-oauth-apps/scopes-for-oauth-apps
# https://docs.github.com/en/rest/users/keys#create-a-public-ssh-key-for-the-authenticated-user
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# https://manp.gs/mac/5/ssh_config#IdentityFile
# https://stackoverflow.com/questions/8402780/preferable-way-to-automatically-update-ssh-config-file-using-python
# https://didokun.medium.com/how-to-configure-multiple-ssh-keys-in-the-same-host-machine-6df74355420