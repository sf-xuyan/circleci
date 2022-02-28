#!/bin/bash

# get started -> bash scripts/shell/packagingDeployment.sh local org2
# required -> replace packageVersionId with the newest one for 2 PACKAGE_VERSION related variables
# desc -> install packages in target org

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
BRANCH=$1
SFDX_CLI_EXEC=sfdx
TARGET_ORG=''
packagePassword=Pa55word
# packageAliases
PACKAGE_VERSION_BASE="base@0.1.0-1-base"
PACKAGE_VERSION_PKG1="my_pkg1@0.1.0-3-pkg1"

# "$#" -> the num of parameters
if [ "$#" -eq 0 ]; then
  echo "No parameter provided, this will be full package installation"
fi

if [ "$#" -eq 2 ]; then
  TARGET_ORG="-u $2"
  echo "Using specific org $2"
fi

# Defining Salesforce CLI exec, depending if it's CI or local dev machine
if [ $CI ]; then
  echo "Script is running on CI"
  SFDX_CLI_EXEC=node_modules/sfdx-cli/bin/run
  TARGET_ORG="-u ciorg"
fi

# Reading the to be installed package version (start with 04t) based on the alias@version key from sfdx-project.json
PACKAGE_VERSION_BASE="$(cat sfdx-project.json | jq --arg VERSION "$PACKAGE_VERSION_BASE" '.packageAliases | .[$VERSION]' | tr -d '"')"
PACKAGE_VERSION_PKG1="$(cat sfdx-project.json | jq --arg VERSION "$PACKAGE_VERSION_PKG1" '.packageAliases | .[$VERSION]' | tr -d '"')"

# We're in a packaging/* branch, so we need to create a new version
if [ $BRANCH = *"base"* ]; then
  echo "Creating new package version for base"
  PACKAGE_VERSION_BASE="$($SFDX_CLI_EXEC force:package:version:create -p base-app -x -w 10 --json | jq '.result.SubscriberPackageVersionId' | tr -d '"')"
  sleep 300 # We've to wait for package replication.
fi
if [ $BRANCH = *"pkg1"* ]; then
  echo "Creating new package version for pkg1"
  PACKAGE_VERSION_PKG1="$($SFDX_CLI_EXEC force:package:version:create -p pkg1-app -x -w 10 --json | jq '.result.SubscriberPackageVersionId' | tr -d '"')"
  sleep 300 # We've to wait for package replication.
fi

# Installation in dependency order
echo "Package installation base"
$SFDX_CLI_EXEC force:package:install -p $PACKAGE_VERSION_BASE -k $packagePassword -w 10 $TARGET_ORG
echo "Package installation pkg1"
$SFDX_CLI_EXEC force:package:install -p $PACKAGE_VERSION_PKG1 -k $packagePassword -w 10 $TARGET_ORG
echo "Done"
