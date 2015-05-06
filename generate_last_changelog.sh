#!/bin/bash

AOSP_DIRECTORY=$1
WORK_DIRECTORY=./aosp/checkouts/build

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

# Retrieve the tag right before the target one
LAST_TAGS=$(git for-each-ref refs/tags --sort=refname --format='%(refname)'  | grep -o 'android\-[0-9][\.0-9]*_.*')
TAGS_ARRAY=(`echo $LAST_TAGS | tr "," "\n"`)

for (( t=1; t<${#TAGS_ARRAY[@]}; t++ ))
do
   if [ ${TAGS_ARRAY[$t]} = $TARGET_TAG ]
   then
     PREVIOUS_TAG=${TAGS_ARRAY[$t-1]}
     break
   fi        
done

echo "Generating changelog from $PREVIOUS_TAG to $TARGET_TAG"

# Update the AOSP working directory with a repo sync to the target tag
cd $AOSP_DIRECTORY
repo init -u https://android.googlesource.com/platform/manifest -b $TARGET_TAG
repo sync

./get_gitlog.sh $PREVIOUS_TAG $TARGET_TAG
