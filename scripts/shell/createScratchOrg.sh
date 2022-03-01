#!/bin/bash
# get started -> bash scripts/shell/createScratchOrg.sh base packaging
# desc: used for creating one-time feature or packaing scratch org, the auth.url will be used as ci env variable

. scripts/shell/util.sh

devHubName=DevHub
subscribers=(base pkg1)
scratchOrgName=$1
defaultGroup="feature" # suggested value: feature, packaging
scratchDefPath=""
navigationURLPath=lightning

# validation rule - param not null
if [ "$#" -eq 0 ]; then
    showErrLog "No scratchOrgName parameter provided, available value -> ${subscribers[*]}. [optional param: defaultGroup]."
fi

if [ "$#" -eq 2 ]; then
    defaultGroup=$2
fi

# validation rule - param1 must be in subscribers
[[ ${subscribers[*]} =~ (^|[[:space:]])"$scratchOrgName"($|[[:space:]]) ]] && scratchDefPath="config/$scratchOrgName-scratch-def.json" || showErrLog "scratchOrgName must be one of the -> ${subscribers[*]}."

# Defining Salesforce CLI exec, depending if it's CI or local dev machine
# if [ $CI ]; then
#     scratchDefPath=config/project-scratch-def.json
# fi

sfdx force:config:set defaultdevhubusername=$devHubName
scratchOrgName="$defaultGroup/$scratchOrgName"
echo "Final scratch org name: $scratchOrgName"

sfdx force:org:delete -u $scratchOrgName -p
sfdx force:org:create -s -f $scratchDefPath -a $scratchOrgName -v $devHubName -d 30
# set random pwd for new created org
sfdx force:user:password:generate -c 3 -l 8 -u $scratchOrgName
# show org info
sfdx force:config:set defaultusername=$scratchOrgName
# sfdxAuthUrl will be shown only when DevHub is authed by web method.
sfdx force:org:display -u $scratchOrgName --json --verbose
sfdx force:org:open -u $scratchOrgName -p $navigationURLPath