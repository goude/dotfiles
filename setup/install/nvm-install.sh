#!/usr/bin/env bash
# change to clone repo instead, see instructions at
# https://github.com/creationix/nvm/blob/master/README.markdown#install-script
#curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

nvm install 22
