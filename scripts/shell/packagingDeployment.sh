#!/bin/bash

# get started -> bash scripts/shell/packagingDeployment.sh all org1 none
# required -> replace packageVersionId with the newest one for 2 PACKAGE_VERSION related variables
# desc -> install packages in target org

. scripts/shell/util.sh

# Script for packaging branch creation

# Instructions:
#
# - It uses the CIRCLE_BRANCH environment variable as first parameter, passed via the
#   CircleCI job config, as value to determine for which package a new version should
#   be created and which packages should only be deployed. It also uses the CI environment
#   variable as safeguard for making sure that the script runs in the CI environment.
# - For a manual run from a developer workstation pass the name of the the package alias
#   as parameter (instead of the CIRCLE_BRANCH environment variable).

# Default values
subscribers=(base pkg1 all)
PACKAGE=$1
TARGET_ORG="-u $2" # required
BRANCH=$3 # required - [none, release]
HUB_ORG=$4 # required for branch = release
SFDX_CLI_EXEC=sfdx
packagePassword=Pa55word
# packageAliases
PACKAGE_VERSION_BASE="base@0.1.0-1-base"
PACKAGE_VERSION_PKG1="pkg1@0.1.0-1-pkg1"

# validation rule - param1 must be in subscribers
if [[ ! ${subscribers[*]} =~ (^|[[:space:]])"$PACKAGE"($|[[:space:]]) ]]; then
    showErrLog "No PACKAGE parameter provided, available value -> ${subscribers[*]}."
fi

# validation rule - param2 must be specified
if [ "$#" -eq 1 ]; then
    showErrLog "No TARGET_ORG parameter provided."
fi

echo "Installation org is: $2"

# validation rule - param3 must be specified
if [ "$#" -eq 2 ]; then
    showErrLog "No BRANCH parameter provided."
fi

echo "BRANCH is: $3"

# validation rule - param4 must be specified only when BRANCH = release
if [[ "$BRANCH" = "release" && "$#" -eq 3 ]]; then
    showErrLog "No HUB_ORG parameter provided."
fi

$SFDX_CLI_EXEC force:org:display -u $TARGET_ORG
$SFDX_CLI_EXEC force:org:display -u $HUB_ORG

# Defining Salesforce CLI exec, depending if it's CI or local dev machine
if [ $CI ]; then
  echo "Script is running on CI"
  SFDX_CLI_EXEC=node_modules/sfdx-cli/bin/run
fi

# Reading the to be installed package version (start with 04t) based on the alias@version key from sfdx-project.json
PACKAGE_VERSION_BASE="$(cat sfdx-project.json | jq --arg VERSION "$PACKAGE_VERSION_BASE" '.packageAliases | .[$VERSION]' | tr -d '"')"
PACKAGE_VERSION_PKG1="$(cat sfdx-project.json | jq --arg VERSION "$PACKAGE_VERSION_PKG1" '.packageAliases | .[$VERSION]' | tr -d '"')"

echo "Base verId extracted from json file: $PACKAGE_VERSION_BASE."
echo "Base verId extracted from json file: $PACKAGE_VERSION_PKG1."

# Installation in dependency order
if [[ $PACKAGE = "base" || $PACKAGE = "all" ]]; then
  if [ $BRANCH = "release" ]; then
    echo "Creating new package version for base"
    PACKAGE_VERSION_BASE="$($SFDX_CLI_EXEC force:package:version:create -v $HUB_ORG -d base-app -p base -k $packagePassword -w 10 --json | jq '.result.SubscriberPackageVersionId' | tr -d '"')"
    echo "Newly created pkg version: $PACKAGE_VERSION_BASE"
    sleep 10 # We've to wait for package replication.
  fi
  echo "Package installation base"
  $SFDX_CLI_EXEC force:package:install -p $PACKAGE_VERSION_BASE -k $packagePassword -w 10 $TARGET_ORG
fi

if [[ $PACKAGE = "pkg1" || $PACKAGE = "all" ]]; then
  if [ $BRANCH = "release" ]; then
    echo "Creating new package version for pkg1"
    PACKAGE_VERSION_PKG1="$($SFDX_CLI_EXEC force:package:version:create -v $HUB_ORG -d pkg1-app -p pkg1 -k $packagePassword -w 10 --json | jq '.result.SubscriberPackageVersionId' | tr -d '"')"
    echo "Newly created pkg version: $PACKAGE_VERSION_PKG1"
    sleep 10 # We've to wait for package replication.
  fi
  echo "Package installation pkg1"
  $SFDX_CLI_EXEC force:package:install -p $PACKAGE_VERSION_PKG1 -k $packagePassword -w 10 $TARGET_ORG
fi

echo "Done"