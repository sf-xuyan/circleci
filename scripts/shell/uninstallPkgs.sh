#!/bin/bash

# get started -> bash scripts/shell/uninstallPkgs.sh "my_pkg1@0.1.0-3-pkg1,base@0.1.0-1-base" org2
# desc -> uninstall the installed pkgs in org

if [ "$#" -eq 0 ]; then
    # ID (starts with 04t) or alias of the package version to uninstall
    echo "Enter the packageAliases or Id (start with 04t) split by comma..."
    exit
fi

packages=$1
target=$2

# for loop to uninstall pkgs
IFS="," read -ra pkgs <<< "$packages"
for pkg in "${pkgs[@]}"; do
    echo "start to uninstall pkg: $pkg"
    sfdx force:package:uninstall -p "$pkg" -u $target
done