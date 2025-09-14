#!/usr/bin/env bash
set -e

sudo apt update
sudo apt install ansible
ansible-playbook -k base.yml

cd install

./install-homeshick.sh
./install-binary-tools.sh

./install-nvm.sh
./update-node-packages.sh

cd ..
cd rcpy

./setup-neovim3-venv.sh
