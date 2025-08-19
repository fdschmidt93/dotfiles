#!/bin/bash
sudo apt update
sudo apt install -y fish stow rigrep fd-find
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
stow -t $HOME nvim
stow -t $HOME fish
