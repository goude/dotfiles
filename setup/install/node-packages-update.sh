#!/bin/bash
source "$HOME/.nvm/nvm.sh"
nvm use node

npm install -g npm@latest jsonlint eslint tern neovim prettier stylelint stylelint-config-recommended yarn textlint live-server
