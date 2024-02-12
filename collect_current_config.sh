#!/bin/bash

mkdir -p ./nvim
mkdir -p ./fish
mkdir -p ./awesome

cp -r $HOME/.config/nvim/* ./nvim
cp -r $HOME/.config/fish/* ./fish
cp -r $HOME/.config/awesome/* ./awesome

rm -r ./nvim/spell
rm ./fish/fish_variables
rm -r ./fish/functions
