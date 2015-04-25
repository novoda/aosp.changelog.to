#!/bin/sh

# This script does a diff of the tags for AOSP since last time it ran
# if a new tag is found it will email the address given as the first arguemnt

log () {
    echo $@
    echo $@ >> $GIT_LOG
}

ALERT_ADDRESS=$1
AOSP_DIRECTORY=$2

WORK_DIRECTORY=./aosp/checkouts/
GIT_LOG=../../../aosp/build_gitlog
TAGS_FILE=../../../aosp/existing_build_tags

if [ ! -d $WORK_DIRECTORY ]; then
	mkdir -p $WORK_DIRECTORY
fi

cd $WORK_DIRECTORY
if [ ! -d build ]; then 
	git clone https://android.googlesource.com/platform/build 
fi

cd build
if [ ! -f $TAGS_FILE ]; then
    touch $TAGS_FILE
fi

echo ------ >> $GIT_LOG
date >> $GIT_LOG
git pull >> $GIT_LOG 2>&1
git tag -l > $TAGS_FILE.new 2>> $GIT_LOG

diff $TAGS_FILE $TAGS_FILE.new > $TAGS_FILE.diff
rm $TAGS_FILE
mv $TAGS_FILE.new $TAGS_FILE

if [ -s $TAGS_FILE.diff ]; then
    log "New tags found!"
    cat $TAGS_FILE.diff
	mail -s "New AOSP Build Tags" $ALERT_ADDRESS < $TAGS_FILE.diff
    if [ -n "$AOSP_DIRECTORY" ]; then
        ../../../generate_last_changelog.sh $AOSP_DIRECTORY
        ../../../upload_to_gh_pages.sh $AOSP_DIRECTORY
    fi
else
	log "No new tags found"
fi
