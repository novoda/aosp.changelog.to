#!/bin/bash

AOSP_DIRECTORY=$1
WORK_DIRECTORY=./aosp/checkouts/build

# Prepare the AOSP working directory with the templates and executables used for the changelof generation
if [ ! -d $AOSP_DIRECTORY ]; then
    mkdir -p $AOSP_DIRECTORY
fi
cp get_gitlog.sh $AOSP_DIRECTORY/
cp get_project_gitlog.sh $AOSP_DIRECTORY/
cp gitlog_to_html $AOSP_DIRECTORY/
cp -r html_templates $AOSP_DIRECTORY/

# Retrieve the target tag and the one right before
cd $WORK_DIRECTORY
LAST_TAGS=$(git for-each-ref refs/tags --sort=-taggerdate --format='%(refname)' --count=2 | grep -o 'android.*')
TAGS_ARRAY=(`echo $LAST_TAGS | tr "," "\n"`)
TARGET_TAG=${TAGS_ARRAY[0]}
PREVIOUS_TAG=${TAGS_ARRAY[1]}

# Update the AOSP working directory with a repo sync to the target tag
cd $AOSP_DIRECTORY
#repo init -u https://android.googlesource.com/platform/manifest -b $TARGET_TAG
#repo sync

./get_gitlog.sh $PREVIOUS_TAG $TARGET_TAG