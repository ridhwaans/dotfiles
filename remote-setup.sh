#!/usr/bin/env bash

[[ -x `command -v wget` ]] && CMD="wget --no-check-certificate -O -"
[[ -x `command -v curl` ]] >/dev/null 2>&1 && CMD="curl -L"

if [ -z "$CMD" ]; then
  echo "No curl or wget available. Aborting..."
else
  echo "Downloading to ~/dotfiles..."
  mkdir -p $HOME/dotfiles && \
  $CMD https://github.com/ridhwaans/dotfiles/tarball/master | tar -xzv -C $HOME/dotfiles --strip-components=1

  echo "Launching setup..."
  .$HOME/dotfiles/setup.sh
fi
