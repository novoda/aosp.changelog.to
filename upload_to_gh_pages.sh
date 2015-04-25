#!/bin/bash

AOSP_DIRECTORY=$1
LAST_CHANGELOG="$(ls $AOSP_DIRECTORY -1t | head -1)"
LAST_CHANGELOG_PATH="$AOSP_DIRECTORY/$LAST_CHANGELOG"

PUBLISH_DIRECTORY=./publish/
CURRENT_REPO_URL=$(git config --get remote.origin.url)
PUBLISH_BRANCH="gh-pages-test"

# If not existing yet, create the publish dir and init the repo with the publish branch
if [ ! -d $PUBLISH_DIRECTORY ]; then
    mkdir -p $PUBLISH_DIRECTORY
    git clone -b $PUBLISH_BRANCH $CURRENT_REPO_URL $PUBLISH_DIRECTORY
fi

cd $PUBLISH_DIRECTORY
git pull

# Copy the last changelog and commit it
cp $LAST_CHANGELOG_PATH ./
git add .
git commit -am "New changelog: ${LAST_CHANGELOG%.*}"
git push
