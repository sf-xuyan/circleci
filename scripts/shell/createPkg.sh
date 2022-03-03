#!/bin/bash
# get started -> bash scripts/shell/createPkg.sh
# desc -> For manually pkg creation

. scripts/shell/util.sh

devHubName=org2
path=""
packagetype=Unlocked # [Managed | Unlocked]
subscribers=(base pkg1)
packageName=$1
description=$2

# validation rule - param not null
if [ "$#" -eq 0 ]; then
    showErrLog "No packageName parameter provided, available value -> ${subscribers[*]}."
fi

# validation rule - param1 must be in subscribers
[[ ${subscribers[*]} =~ (^|[[:space:]])"$packageName"($|[[:space:]]) ]] && path="$packageName-app" || showErrLog "packageName must be one of the -> ${subscribers[*]}."

# validation rule - param2 nice to have
if [ "$#" -eq 1 ]; then
    showErrLog "No description parameter provided, nice to have."
fi

# create package - If you don't have a namespace defined in your sfdx-project.json file, use --nonamespace.
sfdx force:package:create -n $packageName -d "$description" -t $packagetype -r $path -v $devHubName -e