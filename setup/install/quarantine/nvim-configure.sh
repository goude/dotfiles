#!/usr/bin/env bash
set -e

rm -rf ~/.local/share/nvim
cd ~/.config/nvim
~/.config/nvim/install_packer.sh
~/.config/nvim/install_lang_servers.sh

echo "Hint: :TSUpdate may fix treesitter problems."
