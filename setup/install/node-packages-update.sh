#!/bin/bash
#FIXME: some of these have been useful to have for neovim etc - now using mostly lazyvim so see what is needed and what can be left out
# shellcheck disable=SC1091
source "$HOME/.nvm/nvm.sh"
nvm use node

npm install -g npm@latest jsonlint eslint tern neovim prettier stylelint stylelint-config-recommended yarn textlint live-server
