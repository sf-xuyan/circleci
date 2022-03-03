#!/bin/bash

# get started -> bash scripts/shell/api-limits-check.sh org2

# ref: https://www.baeldung.com/linux/jq-command-json
# ref: https://stedolan.github.io/jq/manual/

. scripts/shell/util.sh

# validation rule - param not null
if [ "$#" -eq 0 ]; then
    showErrLog "You must specify the target org you want to check."
fi

targetOrg=$1

# sfdx force:limits:api:display -u $targetOrg

queryAPILimits() {
    echo "start to query the api limits in $targetOrg..."
    local result=$(sfdx force:limits:api:display -u $targetOrg --json | jq -r '.result[] | select(.remaining == 1 or .name == ("ActiveScratchOrgs", "DailyScratchOrgs", "Package2VersionCreates", "Package2VersionCreatesWithoutValidation")) | .name, .max, .remaining')
    echo "API -> Max -> Remaining"
    printf "%s -> %d -> %d\n" $result
}

# list the api exeeded the daily limits
queryAPILimits