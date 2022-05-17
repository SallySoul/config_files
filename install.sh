#!/usr/bin/env bash
CONFIG_DIR=`pwd` &&
mkdir -p ~/.config &&
rm -rf ~/.config/nvim &&
rm -rf ~/.zshrc &&
rm -rf ~/.tmux.conf &&

ln -s "${CONFIG_DIR}/tmux/tmux.conf" ~/.tmux.conf &&
ln -s "${CONFIG_DIR}/zsh/zshrc" ~/.zshrc &&
ln -s "${CONFIG_DIR}/nvim" ~/.config/nvim
