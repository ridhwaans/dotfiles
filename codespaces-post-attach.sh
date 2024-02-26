#!/usr/bin/env bash

# Run any additional user-specific hooks. This runs every time the container is attached.
# See https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-personalization-for-codespaces#troubleshooting-dotfiles for more

# Stash changes if there are any
if [ -n "$(git status --porcelain)" ]; then
    git stash save "Stashed changes before switching branches"
fi

default_branch=$(git remote show origin | grep 'HEAD branch' | cut -d ':' -f 2 | xargs)

# Switch to default branch, pull latest changes from origin, and switch back to previous branch
git checkout "$default_branch" && git pull origin "$default_branch" && git checkout -

# Pop stashed changes if any
[ -n "$(git stash list)" ] && git stash pop

