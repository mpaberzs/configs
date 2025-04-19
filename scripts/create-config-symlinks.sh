#!/usr/bin/env bash
# create symlinks
CONFIGS_DIR="$HOME/.scripts/git/configs"
# TODO: hide output from "file"
# file -E $HOME/.scripts || mkdir $HOME/.scripts
# file -E $HOME/.scripts/git || mkdir $HOME/.scripts/git
# file -E $CONFIGS_DIR || git clone git@github.com:mpaberzs/configs.git $CONFIGS_DIR
# ln -s $CONFIGS_DIR/nvim/coding_config $HOME/.config/nvim 
# ln -s $CONFIGS_DIR/wezterm $HOME/.config/wezterm
# ln -s $CONFIGS_DIR/xmonad $HOME/.config/xmonad
# ln -s $CONFIGS_DIR/xmobar $HOME/.config/xmobar
ln -s $CONFIGS_DIR/zsh/.zshrc $HOME/.zshrc

# remove symlinks
# rm -rf $HOME/.config/nvim
# rm -rf $HOME/.config/wezterm
# rm -rf $HOME/.config/xmonad
# rm -rf $HOME/.config/xmobar
