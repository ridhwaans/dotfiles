#!/bin/bash

# Personal access token (PAT)
# Token (classic)
# scopes -- repo, admin:public_key
# no expiration date, or set a 90 day expiration to authorize single-sign-on organization access
# 
# Usage:
#   chmod +x autokey-github.sh
#   ./autokey-github.sh <KEY_NAME> <GH_TOKEN>

#set -e

# Generate SSH Key and Deploy to Github
KEY_NAME=$1
GH_TOKEN=$2

ssh-keygen -t ed25519 -C $1 -f ~/.ssh/$KEY_NAME

PUBKEY=`cat ~/.ssh/$KEY_NAME.pub`

RESPONSE=`curl -s -H "Authorization: token ${GH_TOKEN}" \
  -X POST --data-binary "{\"title\":\"${KEY_NAME}\",\"key\":\"${PUBKEY}\"}" \
  https://api.github.com/user/keys`

KEYID=`echo $RESPONSE \
  | grep -o '\"id.*' \
  | grep -o "[0-9]*" \
  | grep -m 1 "[0-9]*"`

echo "Public key deployed to remote service"

# Add SSH Key to the local ssh-agent"

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/$KEY_NAME

echo "Added SSH key to the ssh-agent"

# Test the SSH connection

ssh -T git@github.com

defaults=("id_dsa" "id_ecdsa" "id_ed25519" "id_rsa")
if [[ ! " ${defaults[*]} " =~ " ${KEY_NAME} " ]]; then
    echo "Key loaded in ssh-agent does not have a default filename. IdentityFile must be configured in ~/.ssh/config"
fi

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