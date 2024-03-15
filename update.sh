#!/bin/bash

# List of all submodules
declare -a submodules=("LuaSnip" "conform.nvim" "gitsigns.nvim" "indent-blankline.nvim" "lazy.nvim" "nvim-cmp" "nvim-lspconfig" "nvim-tree.lua" "nvim-treesitter" "nvim-web-devicons" "plenary.nvim")

# Update each submodule
for submodule in "${submodules[@]}"
do
    echo "Updating $submodule..."
    cd $submodule
    git add .
    git commit -m "Update changes in $submodule"
    cd ..
done

# Update the main project
echo "Updating main project..."
git add .
git commit -m "Update submodule references"
git push

echo "All submodules and main project updated."

