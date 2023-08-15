#!/bin/bash
set -eu

# Initializes core configs and backs up existing files if needed
REMOTE_DOTFILES="https://raw.githubusercontent.com/bryce-evans/dotfiles/master/"

for config in .bashrc .gitconfig; do 
  test -f ${config} && cp ${config} ${config}-$(date +%s)
  curl -o ${config} ${REMOTE_DOTFILES}${config}
done

