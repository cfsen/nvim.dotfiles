#!/bin/bash

echo "WARNING!"
echo "This will overwrite the files in this directory."
echo "Press enter to continue."

read

mkdir -p ./lua/

cp -v ~/.config/nvim/init.lua .
cp -v ~/.config/nvim/lua/*.lua lua/
