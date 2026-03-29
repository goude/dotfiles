#FIXME: intent here is to get the latest stable version - would be great if it could work for both standard docker container,running on bare metal linux, and rpi 500 and also macos
#!/usr/bin/env bash
set -e

mkdir -p ~/.nvim/
rm -rf ~/.nvim/nvim-linux64
cd ~/.nvim/

#wget https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz
wget https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-arm64.tar.gz
tar xvzf nvim-linux-arm64.tar.gz

rm nvim-linux-arm64.tar.gz
rm -f ~/bin/nvim

ln -s ~/.nvim/nvim-linux-arm64/bin/nvim ~/bin/
