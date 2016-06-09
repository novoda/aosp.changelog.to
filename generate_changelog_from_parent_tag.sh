#!/bin/bash

TARGET_TAG=$1
AOSP_DIRECTORY=$2

WORK_DIRECTORY=./aosp/checkouts/build
cd $WORK_DIRECTORY

# Retrieve the tag right before the target one
PARENT_TAG=$(git describe --abbrev=0 --tags $TARGET_TAG^)

echo "Generating changelog from $PARENT_TAG to $TARGET_TAG"

# Update the AOSP working directory with a repo sync to the target tag
cd $AOSP_DIRECTORY
repo init -u https://android.googlesource.com/platform/manifest -b $TARGET_TAG
repo sync

./get_gitlog.sh $PARENT_TAG $TARGET_TAG
