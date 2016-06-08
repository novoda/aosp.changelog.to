#!/bin/bash

AOSP_DIRECTORY=$1
WORK_DIRECTORY=./aosp/checkouts/build
GENERATOR_BASE_DIR=$(pwd)

# Prepare the AOSP working directory with the templates and executables used for the changelog generation
if [ ! -d $AOSP_DIRECTORY ]; then
    mkdir -p $AOSP_DIRECTORY
fi
cp get_gitlog.sh $AOSP_DIRECTORY/
cp get_project_gitlog.sh $AOSP_DIRECTORY/
cp gitlog_to_html $AOSP_DIRECTORY/
cp -r html_templates $AOSP_DIRECTORY/

# Retrieve the target tag
cd $WORK_DIRECTORY
LAST_TAGS=$(git for-each-ref refs/tags --sort=-taggerdate --format='%(refname)' | grep -o 'android\-[0-9][\.0-9]*_.*')
TAGS_ARRAY=(`echo $LAST_TAGS | tr "," "\n"`)
TARGET_TAG=${TAGS_ARRAY[0]}

echo "Target: $TARGET_TAG"
cd $GENERATOR_BASE_DIR
./generate_changelog_from_parent_tag.sh $TARGET_TAG $AOSP_DIRECTORY
