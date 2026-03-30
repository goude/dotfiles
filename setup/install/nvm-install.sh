#!/usr/bin/env bash
#FIXME: here we want a stable solution-it should get a good stable version needn't be the latest of node, so 22 for now is fine make configurable
# change to clone repo instead, see instructions at
# https://github.com/creationix/nvm/blob/master/README.markdown#install-script
#curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install 22
