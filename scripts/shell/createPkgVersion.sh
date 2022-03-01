#!/bin/bash
# get started -> bash scripts/shell/createPkgVersion.sh
# desc -> For manually pkg version creation

. scripts/shell/util.sh

devHubName=DevHub
path=''
subscribers=(base pkg1)
packageName=$1
packagePassword=Pa55word

# validation rule - param not null
if [ "$#" -eq 0 ]; then
    showErrLog "No packageName parameter provided, available value -> ${subscribers[*]}."
fi

# validation rule - param must be in subscribers
[[ ${subscribers[*]} =~ (^|[[:space:]])"$packageName"($|[[:space:]]) ]] && path="$packageName-app" || showErrLog "packageName must be one of the -> ${subscribers[*]}."

# create version
sfdx force:package:version:create -p $packageName -d $path -k $packagePassword -w 30 -v $devHubName
# sfdx force:package:version:update -p 04t... -b main -t 'Release 1.0.7'